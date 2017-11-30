# SCRIPT AUTOMATIZADO CAD
#
#
#

import Draft

import Sketcher

import Part 

import Mesh

import MeshPart

import PartDesign

from math import cos, sin

from math import *

import FreeCAD 

App.newDocument("TOBERA")

App.setActiveDocument("TOBERA")

App.ActiveDocument=App.getDocument("TOBERA")

import os

PWD=str(os.getcwd())


############################## PARAMETROS DE CONTROL DE MALLADO ###

m_tobera=.0015

m_flex=.0015

m_salida=.005

############################### DATOS BASE #########################

### TODOS LOS DATOS SE ENCUENTRAN EN mm LUEGO SE
### PASAN AUTOMATICAMENTE A METROS

HOT=float(.8*500*.4/3)

FLEX=float(.8*500*.4/2)

LT=float(.8*500/2)

D2=float(25.4)

D3=float(18)


############################### DATOS DEDUCIDOS ##############

### PASE DE DATOS A METROS


hot=HOT/1000

flex=FLEX/1000

lt=LT/1000

d2=D2/1000 

d3=D3/1000

#//// Angulo de rotacion (Grados)

alfa=10  


########################### FUNCIONES #################


### Rotacion punto guia para fillet

beta = alfa * pi/180

cos_theta, sin_theta = cos(beta), sin(beta)

x0, y0 = 0, 0 # origen

x, y = 0 - x0, -hot - y0

guiaRotX = x * cos_theta - y * sin_theta + x0

guiaRotY = x * sin_theta + y * cos_theta + y0



# // BOCA DE TUBO

App.activeDocument().addObject('Sketcher::SketchObject','BOCA_TUBO')

App.ActiveDocument.BOCA_TUBO.Placement = App.Placement(App.Vector(0.000000,0.000000,0.000000),App.Rotation(-0.707107,0.000000,0.000000,-0.707107)) # PLANO XZ

App.ActiveDocument.BOCA_TUBO.addGeometry(Part.Circle(App.Vector(0,0,0),App.Vector(0,0,1),d2))

App.getDocument('TOBERA').recompute()


# // BOCA TOBERA

App.activeDocument().addObject('Sketcher::SketchObject','BOCA_TOBERA')

App.ActiveDocument.BOCA_TOBERA.Placement = App.Placement(App.Vector(0.000000,-hot,0.00000),App.Rotation(-0.707107,0.000000,0.000000,-0.707107)) # PLANO XZ

App.ActiveDocument.BOCA_TOBERA.addGeometry(Part.Circle(App.Vector(0,0,0),App.Vector(0,0,1),d2))

App.getDocument('TOBERA').recompute()

# // SALIDA TOBERA

App.activeDocument().addObject('Sketcher::SketchObject','SALIDA_TOBERA')

App.ActiveDocument.SALIDA_TOBERA.Placement = App.Placement(App.Vector(0.000000,-hot-lt,0.00000),App.Rotation(-0.707107,0.000000,0.000000,-0.707107)) # PLANO XZ

App.ActiveDocument.SALIDA_TOBERA.addGeometry(Part.Circle(App.Vector(0,0,0),App.Vector(0,0,1),d3))

App.getDocument('TOBERA').recompute()

#############  FLEXIBLE #####################


# // BOCA TOBERA DEZPLAZADA

App.activeDocument().addObject('Sketcher::SketchObject','BOCA_TOBERA_ALFA')

beta = alfa * pi/180

cos_theta, sin_theta = cos(beta), sin(beta)

x0, y0 = 0, 0 # origen

x, y = 0 - x0, -hot - y0

guiaRotX = x * cos_theta - y * sin_theta + x0

guiaRotY = x * sin_theta + y * cos_theta + y0

App.ActiveDocument.BOCA_TOBERA_ALFA.Placement = App.Placement(App.Vector(guiaRotX,guiaRotY,0.00000),App.Rotation(FreeCAD.Vector(0,0,1),alfa)) 

App.ActiveDocument.BOCA_TOBERA_ALFA.addGeometry(Part.Circle(App.Vector(0,0,0),App.Vector(0,1,0),d2))

App.getDocument('TOBERA').recompute()

# // BOCA TOBERA DEZPLAZADA INTER

App.activeDocument().addObject('Sketcher::SketchObject','BOCA_TOBERA_ALFA_INTER')

beta = alfa/2 * pi/180

cos_theta, sin_theta = cos(beta), sin(beta)

x0, y0 = 0, 0 # origen

x, y = 0 - x0, -hot/2 - y0

guiaRotX = x * cos_theta - y * sin_theta + x0

guiaRotY = x * sin_theta + y * cos_theta + y0

App.ActiveDocument.BOCA_TOBERA_ALFA_INTER.Placement = App.Placement(App.Vector(guiaRotX,guiaRotY,0.00000),App.Rotation(FreeCAD.Vector(0,0,1),alfa)) 

App.ActiveDocument.BOCA_TOBERA_ALFA_INTER.addGeometry(Part.Circle(App.Vector(0,0,0),App.Vector(0,1,0),d2))

App.getDocument('TOBERA').recompute()



############################ EXTRUSION CON GEOMETRIA COMO GUIA



App.getDocument('TOBERA').addObject('Part::Loft','TOBERA')

App.getDocument('TOBERA').ActiveObject.Sections=[App.getDocument('TOBERA').BOCA_TOBERA, App.getDocument('TOBERA').SALIDA_TOBERA]

App.getDocument('TOBERA').ActiveObject.Solid=False

App.getDocument('TOBERA').ActiveObject.Ruled=True

App.getDocument('TOBERA').ActiveObject.Closed=False

App.getDocument('TOBERA').recompute()


App.getDocument('TOBERA').addObject('Part::Loft','FLEXIBLE')

App.getDocument('TOBERA').ActiveObject.Sections=[App.getDocument('TOBERA').BOCA_TUBO, App.getDocument('TOBERA').BOCA_TOBERA_ALFA_INTER, App.getDocument('TOBERA').BOCA_TOBERA_ALFA]

App.getDocument('TOBERA').ActiveObject.Solid=False

App.getDocument('TOBERA').ActiveObject.Ruled=True

App.getDocument('TOBERA').ActiveObject.Closed=False

App.getDocument('TOBERA').recompute()


####################### ROTACION ########################

##rotacion(int(45),'TOBERA')

obj = App.getDocument('TOBERA').TOBERA                       

rot = FreeCAD.Rotation(FreeCAD.Vector(0,0,1),alfa)   

centre = FreeCAD.Vector(0,0,0)                  

pos = obj.Placement.Base                        

newplace = FreeCAD.Placement(pos,rot,centre)    

obj.Placement = newplace          

App.getDocument('TOBERA').recompute()

#####################  CARAS ENTRADA y SALIDA ############

Part.Face(Part.Wire(Part.__sortEdges__([App.ActiveDocument.TOBERA.Shape.Edge1, ])))

App.ActiveDocument.addObject('Part::Feature','SALIDA').Shape=_

######################    MALLADO  #####################  


__doc__=FreeCAD.getDocument("TOBERA")

__mesh__=__doc__.addObject("Mesh::Feature","tobera_mesh")

__mesh__.Mesh=MeshPart.meshFromShape(Shape=__doc__.getObject("TOBERA").Shape,MaxLength=m_tobera)

__mesh__.Label="tobera_mesh"

del __doc__, __mesh__


__doc__=FreeCAD.getDocument("TOBERA")

__mesh__=__doc__.addObject("Mesh::Feature","flexible_mesh")

__mesh__.Mesh=MeshPart.meshFromShape(Shape=__doc__.getObject("FLEXIBLE").Shape,MaxLength=m_flex)

__mesh__.Label="flexible_mesh"

del __doc__, __mesh__


__doc__=FreeCAD.getDocument("TOBERA")

__mesh__=__doc__.addObject("Mesh::Feature","salida_mesh")

__mesh__.Mesh=MeshPart.meshFromShape(Shape=__doc__.getObject("SALIDA").Shape,MaxLength=m_salida)

__mesh__.Label="salida_mesh"

del __doc__, __mesh__


################### CREADO DE ARCHIVO STL ################


FreeCAD.ActiveDocument.getObject("tobera_mesh").Mesh.write(PWD+"/bin/tobera.stl","STL","tobera_mesh")

FreeCAD.ActiveDocument.getObject("tobera_mesh").Mesh.write(PWD+"/ascii/tobera_ascii.stl","AST","tobera_mesh")


FreeCAD.ActiveDocument.getObject("flexible_mesh").Mesh.write(PWD+"/bin/flexible.stl","STL","flexible_mesh")

FreeCAD.ActiveDocument.getObject("flexible_mesh").Mesh.write(PWD+"/ascii/flexible_ascii.stl","AST","flexible_mesh")


FreeCAD.ActiveDocument.getObject("salida_mesh").Mesh.write(PWD+"/bin/salida.stl","STL","salida_mesh")

FreeCAD.ActiveDocument.getObject("salida_mesh").Mesh.write(PWD+"/ascii/salida_ascii.stl","AST","salida_mesh")

