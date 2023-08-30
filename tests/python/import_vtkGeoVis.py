import vtk
import numpy as np
from vtkmodules.vtkGeovisCore import vtkGeoProjection, vtkGeoTransform

def mklatloncurvilineargrid():
	latrange = (-75.0, 75.0)
	latstep = 1
	lonrange = (-180.0,180.0)
	lonstep = 2
	points = vtk.vtkPoints()
	dataset = vtk.vtkStructuredGrid()
	data = vtk.vtkFloatArray()
	data.SetName("vertical stripes")

	latitudes = np.arange(latrange[0],latrange[1],latstep).tolist()

	longitudes = np.arange(lonrange[0], lonrange[1],lonstep).tolist()

	# Make the Point List for the Curvilinear Grid
	# Also make a scalar field pattern:vertical lines every 10 degrees
	# longitude
	point_count = 0
	for lat in latitudes:
		for lon in longitudes:
			points.InsertPoint(point_count, lon, lat, 0.0)
			data.InsertNextValue( int(lon/10) % 2 )
			point_count += 1

	dataset.SetDimensions(len(longitudes),len(latitudes),1)
	dataset.SetPoints(points)
	dataset.GetPointData().AddArray(data)

	return dataset


def ConvertLatLonToRobinson(lonlatdataset):
	LATLonString = ""
	RobinsonString = "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
	LonLatString = "+proj=lonlat +ellps=WGS84"
	LonLatString = ""
	transform = vtkGeoTransform()
	source_projection = vtkGeoProjection()
	destination_projection = vtkGeoProjection()
	destination_projection.SetPROJ4String(RobinsonString)
	source_projection.SetPROJ4String(LonLatString)
	#transform.SetSourceProjection(source_projection)
	transform.SetDestinationProjection(destination_projection)
	newPoints = vtk.vtkPoints()
	transform.TransformPoints(lonlatdataset.GetPoints(),newPoints)
	robinson_dataset = vtk.vtkStructuredGrid()
	dims=[0,0,0]
	print (lonlatdataset.GetDimensions(dims))
	robinson_dataset.SetDimensions(dims)
	robinson_dataset.SetPoints(newPoints)
	robinson_dataset.GetPointData().AddArray(lonlatdataset.GetPointData().GetArray(0))
	return robinson_dataset


mygrid = mklatloncurvilineargrid()
print(mygrid)
robgrid = ConvertLatLonToRobinson(mygrid)
print(robgrid)
