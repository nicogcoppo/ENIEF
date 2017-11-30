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

PWD=str("partesFijas/FcSTL/")


############################## PARAMETROS DE CONTROL DE MALLADO ###

m_tubo=.005

m_pre_tubo=.0025

m_entrada=.005

############################### DATOS BASE #########################

### TODOS LOS DATOS SE ENCUENTRAN EN mm LUEGO SE
### PASAN AUTOMATICAMENTE A METROS

LA=float(500) 

LB=float(0.8*LA)

LC=float(.4*LB)

LD=float(.5*LB)

LT=float(LB/2)

D1=float(25.4*2)

D2=float(25.4)

HL=LC

############################### DATOS DEDUCIDOS ##############

### PASE DE DATOS A METROS

la=LA/1000 

lb=LB/1000

lc=LC/1000

ld=LD/1000

hl=HL/1000 

d1=D1/1000

d2=D2/1000 

########################### FUNCIONES #################


########################### DEFINICION DE LOS SKETECHES

################ // TUBO // ###################

App.activeDocument().addObject('Sketcher::SketchObject','Tubo')

App.ActiveDocument.Tubo.Placement = App.Placement(App.Vector(0.000000,0.000000,0.000000),App.Rotation(0.000000,0.000000,0.000000,1.000000)) # PLANO XY

# // Tramo vertical solidario a tobera LA

App.ActiveDocument.Tubo.addGeometry(Part.Line(App.Vector(0,0,0),App.Vector(0,la,0)))


# // Tramo superior horizontal LB

App.ActiveDocument.Tubo.addGeometry(Part.Line(App.Vector(-hl,la+hl,0),App.Vector(-hl-lb,la+hl,0)))

# // Tramo vertical pequenio LC

App.ActiveDocument.Tubo.addGeometry(Part.Line(App.Vector(-2*hl-lb,la,0),App.Vector(-2*hl-lb,la-lc,0)))

# // Tramo inferior horizontal o de entrada LD

App.ActiveDocument.Tubo.addGeometry(Part.Line(App.Vector(-3*hl-lb,la-lc-hl,0),App.Vector(-3*hl-lb-ld,la-lc-hl,0)))

# // PERFIL LA-B

App.ActiveDocument.Tubo.fillet(1,0,App.Vector(-hl,la+hl,0),App.Vector(0,la,0),hl)

# // PERFIL LB-C

App.ActiveDocument.Tubo.fillet(2,1,App.Vector(-2*hl-lb,la,0),App.Vector(-hl-lb,la+hl,0),hl)


# // PERFIL LC-D

App.ActiveDocument.Tubo.fillet(3,2,App.Vector(-3*hl-lb,la-lc-hl,0),App.Vector(-2*hl-lb,la-lc,0),hl)


App.getDocument('TOBERA').recompute()


########## CIRCUNFERENCIAS ###########

# // BOCA DE PRE-TUBO

App.activeDocument().addObject('Sketcher::SketchObject','BOCA_PRE_TUBO')

App.ActiveDocument.BOCA_PRE_TUBO.Placement = App.Placement(App.Vector(0.000000,la,0.000000),App.Rotation(-0.707107,0.000000,0.000000,-0.707107)) # PLANO XZ

App.ActiveDocument.BOCA_PRE_TUBO.addGeometry(Part.Circle(App.Vector(0,0,0),App.Vector(0,0,1),d1))

App.getDocument('TOBERA').recompute()


# // BOCA DE TUBO

App.activeDocument().addObject('Sketcher::SketchObject','BOCA_TUBO')

App.ActiveDocument.BOCA_TUBO.Placement = App.Placement(App.Vector(0.000000,0.000000,0.000000),App.Rotation(-0.707107,0.000000,0.000000,-0.707107)) # PLANO XZ

App.ActiveDocument.BOCA_TUBO.addGeometry(Part.Circle(App.Vector(0,0,0),App.Vector(0,0,1),d2))

App.getDocument('TOBERA').recompute()


############################ EXTRUSION CON GEOMETRIA COMO GUIA


App.getDocument('TOBERA').addObject('Part::Sweep','TUBO')

App.getDocument('TOBERA').ActiveObject.Sections=[App.getDocument('TOBERA').BOCA_PRE_TUBO]

App.getDocument('TOBERA').ActiveObject.Spine=(App.ActiveDocument.Tubo,["Edge2","Edge3","Edge4","Edge5","Edge6","Edge7"])

App.getDocument('TOBERA').ActiveObject.Solid=False

App.getDocument('TOBERA').ActiveObject.Frenet=True

App.getDocument('TOBERA').recompute()


App.getDocument('TOBERA').addObject('Part::Loft','PRE_TUBO')

App.getDocument('TOBERA').ActiveObject.Sections=[App.getDocument('TOBERA').BOCA_PRE_TUBO,App.getDocument('TOBERA').BOCA_TUBO]

App.getDocument('TOBERA').ActiveObject.Solid=False

App.getDocument('TOBERA').ActiveObject.Ruled=True

App.getDocument('TOBERA').ActiveObject.Closed=False

App.getDocument('TOBERA').recompute()


#####################  CARAS ENTRADA y SALIDA ############

Part.Face(Part.Wire(Part.__sortEdges__([App.ActiveDocument.TUBO.Shape.Edge13, ])))

App.ActiveDocument.addObject('Part::Feature','ENTRADA').Shape=_


######################    MALLADO  #####################  


__doc__=FreeCAD.getDocument("TOBERA")

__mesh__=__doc__.addObject("Mesh::Feature","tubo_mesh")

__mesh__.Mesh=MeshPart.meshFromShape(Shape=__doc__.getObject("TUBO").Shape,MaxLength=m_tubo)

__mesh__.Label="tubo_mesh"

del __doc__, __mesh__


__doc__=FreeCAD.getDocument("TOBERA")

__mesh__=__doc__.addObject("Mesh::Feature","pre_tubo_mesh")

__mesh__.Mesh=MeshPart.meshFromShape(Shape=__doc__.getObject("PRE_TUBO").Shape,MaxLength=m_pre_tubo)

__mesh__.Label="pre_tubo_mesh"

del __doc__, __mesh__


__doc__=FreeCAD.getDocument("TOBERA")

__mesh__=__doc__.addObject("Mesh::Feature","entrada_mesh")

__mesh__.Mesh=MeshPart.meshFromShape(Shape=__doc__.getObject("ENTRADA").Shape,MaxLength=m_entrada)

__mesh__.Label="entrada_mesh"

del __doc__, __mesh__



################### CREADO DE ARCHIVO STL ################


FreeCAD.ActiveDocument.getObject("tubo_mesh").Mesh.write(PWD+"/bin/tubo.stl","STL","tubo_mesh")

FreeCAD.ActiveDocument.getObject("tubo_mesh").Mesh.write(PWD+"/ascii/tubo_ascii.stl","AST","tubo_mesh")


print PWD

FreeCAD.ActiveDocument.getObject("pre_tubo_mesh").Mesh.write(PWD+"/bin/pre_tubo.stl","STL","pre_tubo_mesh")

FreeCAD.ActiveDocument.getObject("pre_tubo_mesh").Mesh.write(PWD+"/ascii/pre_tubo_ascii.stl","AST","pre_tubo_mesh")


FreeCAD.ActiveDocument.getObject("entrada_mesh").Mesh.write(PWD+"/bin/entrada.stl","STL","entrada_mesh")

FreeCAD.ActiveDocument.getObject("entrada_mesh").Mesh.write(PWD+"/ascii/entrada_ascii.stl","AST","entrada_mesh")

