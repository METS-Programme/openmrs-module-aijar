# openmrs-module-aijar
Electronic Medical Records distribution for Uganda

# Managing metadata sharing (MDS) packages
This section outlines the process for adding a new MDS package as well as upgrading an existing MDS.
## Adding a new MDS package
1. Add the MDS package zip file to the [metadata] (https://github.com/METS-Programme/openmrs-module-aijar/tree/master/api/src/main/resources/metadata) folder.
2. Update a definition for the MDS package in the [packages.xml] (https://github.com/METS-Programme/openmrs-module-aijar/blob/master/api/src/main/resources/packages.xml) with an entry for the package, taking care to use a different groupUuid value for the new package.
3. Update the [AijarActivator] (https://github.com/METS-Programme/openmrs-module-aijar/blob/c6c290d529a9f503aefc255568b37ed0be7a62c1/api/src/main/java/org/openmrs/module/aijar/AijarActivator.java) to include the MDS package.

## Upgrading an exsting MDS package
This involves increasing the version number of the MDS package so that it can be installed

1. Add the new MDS package file to the [metadata] (https://github.com/METS-Programme/openmrs-module-aijar/tree/master/api/src/main/resources/metadata) folder.
2. Delete the old MDS package
3. Update the [packages.xml] (https://github.com/METS-Programme/openmrs-module-aijar/blob/master/api/src/main/resources/packages.xml) file with the new version number of the package so that it can be installed


