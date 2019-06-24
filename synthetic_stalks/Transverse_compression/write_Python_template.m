% write_Python_template.m: Use Christopher's Python script for taking
% cross-section points and running an Abaqus case and make a string array
% that can be used to


% IMPORTANT NOTE: This script will not display properly when opened in
% Microsoft Notepad. However, opening in Atom or another text editor will
% show properly formatted code.


Template = {
    'from part import *';
    'from material import *';
    'from section import *';
    'from optimization import *';
    'from assembly import *';
    'from step import *';
    'from interaction import *';
    'from load import *';
    'from mesh import *';
    'from job import *';
    'from sketch import *';
    'from visualization import *';
    'from connectorBehavior import *';
    '';
    '########################User-defined Model-Specific Features #######################';
    '#name of stalk part (will also be name of job and odb file)';
    'jobname = ';
    '#name of model';
    'modelname = jobname';
    '#Stalk ID number';
    'ID = ';
    '#case number (depending on case numbering convention you choose)';
    'case_no = ';
    '#name of output text file (must match looper script)';
    'filename = ''C:/Temp/Results.txt''';
    '#mesh seed size of part';
    'SeedSize = 500';   % CHANGE THE SEED SIZE HERE
    '#deflection of part';
    'PlatenMovement = 5';
    '#rind modulus';
    'rindE = 0.014672916666667';
    '#rind modulus';
    'pithE = 0.0014672916666667';
    '#x location of reference point 1';
    'RP1x = ';
    '#y location of reference point 1';
    'RP1y = ';
    '#x location of reference point 1';
    'RP2x = ';
    '#y location of reference point 1';
    'RP2y = ';
    '#influence area of fake contact constraint';
    'influence = 1000';
    '######################################################################################';
    '';
    '#Define additional parameters';
    'PartName = ''Stalk''';
    'InstanceName = PartName + ''-1''';
    'odbname = jobname + ''.odb''';
    '';
    '#Create new model';
    'mdb.Model(modelType=STANDARD_EXPLICIT, name=modelname)';
    '';
    '#Define outer stalk geometry from spline';
    'mdb.models[modelname].ConstrainedSketch(name=''__profile__'', sheetSize=0.05)';
    'mdb.models[modelname].sketches[''__profile__''].sketchOptions.setValues(';
    '    decimalPlaces=3)';
    '';
    '####################### copy / paste in the x-y data for the outer spline here #######################';
    'mdb.models[modelname].sketches[''__profile__''].Spline(points=(';
    '    ';
    '    ))';
    '######################################################################################################';
    'mdb.models[modelname].Part(dimensionality=TWO_D_PLANAR, name=PartName, type=';
    '    DEFORMABLE_BODY)';
    'mdb.models[modelname].parts[PartName].BaseShell(sketch=';
    '    mdb.models[modelname].sketches[''__profile__''])';
    'del mdb.models[modelname].sketches[''__profile__'']';
    '';
    '#Define rind-pith boundary';
    'mdb.models[modelname].ConstrainedSketch(gridSpacing=0.001, name=''__profile__''';
    '    , sheetSize=0.066, transform=';
    '    mdb.models[modelname].parts[''Stalk''].MakeSketchTransform(';
    '    sketchPlane=mdb.models[modelname].parts[''Stalk''].faces[0],';
    '    sketchPlaneSide=SIDE1, sketchOrientation=RIGHT, origin=(0., 0.,';
    '    0.0)))';
    'mdb.models[modelname].sketches[''__profile__''].sketchOptions.setValues(';
    '    decimalPlaces=3)';
    'mdb.models[modelname].parts[''Stalk''].projectReferencesOntoSketch(filter=';
    '    COPLANAR_EDGES, sketch=mdb.models[modelname].sketches[''__profile__''])';
    '';
    '####################### copy / paste in the x-y data for the inner spline here #######################';
    'mdb.models[modelname].sketches[''__profile__''].Spline(points=(';
    '    ';
    '    ))';
    '######################################################################################################';
    'mdb.models[modelname].parts[''Stalk''].PartitionFaceBySketch(faces=';
    '    mdb.models[modelname].parts[''Stalk''].faces.getSequenceFromMask((''[#1 ]'',';
    '    ), ), sketch=mdb.models[modelname].sketches[''__profile__''])';
    'del mdb.models[modelname].sketches[''__profile__'']';
    '';
    '#Mesh stalk';
    'mdb.models[modelname].parts[PartName].seedPart(deviationFactor=';
    '    0.1, minSizeFactor=0.1, size=SeedSize)';
    'mdb.models[modelname].parts[PartName].setMeshControls(algorithm=';
    '    MEDIAL_AXIS, regions=';
    '    mdb.models[modelname].parts[PartName].faces.getSequenceFromMask(';
    '    (''[#1 ]'', ), ))';
    'mdb.models[modelname].parts[PartName].generateMesh()';
    '';
    '#Define rind material and section';
    'mdb.models[modelname].Material(name=''Rind'')';
    'mdb.models[modelname].materials[''Rind''].Elastic(table=((rindE, 0.25), ))';
    'mdb.models[modelname].HomogeneousSolidSection(material=''Rind'', name=''Rind'',';
    '    thickness=None)';
    '';
    '#Define pith material and section';
    'mdb.models[modelname].Material(name=''Pith'')';
    'mdb.models[modelname].materials[''Pith''].Elastic(table=((pithE, 0.25), ))';
    'mdb.models[modelname].HomogeneousSolidSection(material=''Pith'', name=''Pith'',';
    '    thickness=None)';
    '';
    '#Assign pith material region';
    'mdb.models[modelname].parts[''Stalk''].Set(faces=';
    '    mdb.models[modelname].parts[''Stalk''].faces.getSequenceFromMask((''[#2 ]'', ),';
    '    ), name=''Set-3'')';
    'mdb.models[modelname].parts[''Stalk''].SectionAssignment(offset=0.0, offsetField=';
    '    '''', offsetType=MIDDLE_SURFACE, region=';
    '    mdb.models[modelname].parts[''Stalk''].sets[''Set-3''], sectionName=''Pith'',';
    '    thicknessAssignment=FROM_SECTION)';
    '';
    '#Assign rind material region';
    'mdb.models[modelname].parts[''Stalk''].Set(faces=';
    '    mdb.models[modelname].parts[''Stalk''].faces.getSequenceFromMask((''[#1 ]'', ),';
    '    ), name=''Set-2'')';
    'mdb.models[modelname].parts[''Stalk''].SectionAssignment(offset=0.0, offsetField=';
    '    '''', offsetType=MIDDLE_SURFACE, region=';
    '    mdb.models[modelname].parts[''Stalk''].sets[''Set-2''], sectionName=''Rind'',';
    '    thicknessAssignment=FROM_SECTION)';
    '';
    '#Create Assembly';
    'mdb.models[modelname].rootAssembly.DatumCsysByDefault(CARTESIAN)';
    'mdb.models[modelname].rootAssembly.Instance(dependent=ON, name=';
    '    InstanceName, part=';
    '    mdb.models[modelname].parts[PartName])';
    'mdb.models[modelname].rootAssembly.instances[InstanceName].translate(';
    '    vector=(0.0, 0.0, 0.0))';
    '';
    '#Define reference point locations';
    'mdb.models[modelname].rootAssembly.ReferencePoint(point=(RP1x, RP1y, 0.0))';
    'mdb.models[modelname].rootAssembly.ReferencePoint(point=(RP2x, RP2y, 0.0))';
    '';
    '#Define loading coordinate system';
    'mdb.models[modelname].rootAssembly.DatumCsysByThreePoints(coordSysType=';
    '    CARTESIAN, line2=(1.3e-05, 0.0, 0.0), name=''LoadingCSYS'', origin=(RP1x,';
    '    RP1y, 0.0), point1=(RP2x, RP2y, 0.0))';
    '';
    '#Create analysis step';
    'mdb.models[modelname].StaticStep(name=''Step-1'', previous=''Initial'')';
    '';
    '#Create fixed boundary condition';
    'mdb.models[modelname].rootAssembly.Set(name=''Set-1'', referencePoints=(';
    '    mdb.models[modelname].rootAssembly.referencePoints[5], ))';
    'mdb.models[modelname].DisplacementBC(amplitude=UNSET, createStepName=''Step-1'',';
    '    distributionType=UNIFORM, fieldName='''', fixed=OFF, localCsys=None, name=';
    '    ''BC-1'', region=mdb.models[modelname].rootAssembly.sets[''Set-1''], u1=0.0,';
    '    u2=0.0, ur3=0.0)';
    '';
    '#Create loaded boundary condition';
    'mdb.models[modelname].rootAssembly.Set(name=''Set-2'', referencePoints=(';
    '    mdb.models[modelname].rootAssembly.referencePoints[4], ))';
    'mdb.models[modelname].DisplacementBC(amplitude=UNSET, createStepName=''Step-1'',';
    '    distributionType=UNIFORM, fieldName='''', fixed=OFF, localCsys=';
    '    mdb.models[modelname].rootAssembly.datums[6], name=''BC-2'', region=';
    '    mdb.models[modelname].rootAssembly.sets[''Set-2''], u1=PlatenMovement, u2=UNSET, ur3=';
    '    UNSET)';
    '';
    '#Create fake contact constraints';
    'mdb.models[modelname].rootAssembly.Set(name=''m_Set-3'', referencePoints=(';
    '    mdb.models[modelname].rootAssembly.referencePoints[4], ))';
    'mdb.models[modelname].Coupling(controlPoint=';
    '    mdb.models[modelname].rootAssembly.sets[''m_Set-3''], couplingType=';
    '    DISTRIBUTING, influenceRadius=influence, localCsys=None, name=''Constraint-1'',';
    '    surface=';
    '    mdb.models[modelname].rootAssembly.instances[''Stalk-1''].sets[''Set-2''], u1=';
    '    ON, u2=ON, ur3=ON, weightingMethod=UNIFORM)';
    'mdb.models[modelname].rootAssembly.Set(name=''m_Set-4'', referencePoints=(';
    '    mdb.models[modelname].rootAssembly.referencePoints[5], ))';
    'mdb.models[modelname].Coupling(controlPoint=';
    '    mdb.models[modelname].rootAssembly.sets[''m_Set-4''], couplingType=';
    '    DISTRIBUTING, influenceRadius=influence, localCsys=None, name=''Constraint-2'',';
    '    surface=';
    '    mdb.models[modelname].rootAssembly.instances[''Stalk-1''].sets[''Set-2''], u1=';
    '    ON, u2=ON, ur3=ON, weightingMethod=UNIFORM)';
    '';
    '#Create job';
    'mdb.Job(atTime=None, contactPrint=OFF, description='''', echoPrint=OFF,';
    '    explicitPrecision=SINGLE, getMemoryFromAnalysis=True, historyPrint=OFF,';
    '    memory=90, memoryUnits=PERCENTAGE, model=modelname, modelPrint=OFF,';
    '    multiprocessingMode=DEFAULT, name=jobname, nodalOutputPrecision=SINGLE,';
    '    numCpus=1, numGPUs=0, queue=None, resultsFormat=ODB, scratch='''', type=';
    '    ANALYSIS, userSubroutine='''', waitHours=0, waitMinutes=0)';
    '';
    '#Run job and wait to completion';
    'myJob=mdb.jobs[jobname]';
    'mdb.jobs[jobname].submit(consistencyChecking=OFF)';
    'myJob.waitForCompletion()';
    '';
    '#Query reaction force';
    'odb = openOdb(path=odbname)';
    'numFrame=odb.steps[''Step-1''].frames[-1]';
    'RForce=numFrame.fieldOutputs[''RF'']';
    'regS1 = odb.rootAssembly.nodeSets[''SET-2'']';
    'FX = RForce.getSubset(region=regS1).values[0].data[0]';
    'FY = RForce.getSubset(region=regS1).values[0].data[1]';
    '';
    '#Write to file and close';
    'FileResultsX=open(filename,''a'')';
    'FileResultsX.write(''%10.8E\t'' % (ID))';
    'FileResultsX.write(''%10.8E\t'' % (case_no))';
    'FileResultsX.write(''%10.8E\t'' % (FX))';
    'FileResultsX.write(''%10.8E\n'' % (FY))';
    'odb.close()';
    'FileResultsX.close()';
};


% % Write Python script from the cell array (turn off for using only as a
% % template without writing a script)
% filePh = fopen('features.py','w');
% fprintf(filePh,'%s\n',Template{:});
% fclose(filePh);
