package org.openmrs.module.aijar.api.deploy.bundle;

import org.springframework.stereotype.Component;
import org.openmrs.module.addresshierarchy.AddressField;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ssmusoke on 07/01/2016.
 */
@Component
public class UgandaAddressMetadataBundle extends AddressMetadataBundle {
    /**
     * @return the ordered list of address components that make up the address configuration
     */
    @Override
    public List<AddressComponent> getAddressComponents() {
        List<AddressComponent> l = new ArrayList<AddressComponent>();
        l.add(new AddressComponent(AddressField.COUNTRY, "aijar.address.country", 40, "Uganda", true));
        l.add(new AddressComponent(AddressField.COUNTY_DISTRICT, "aijar.address.district", 40, null, true));
        l.add(new AddressComponent(AddressField.STATE_PROVINCE, "aijar.address.county", 40, null, true));
        l.add(new AddressComponent(AddressField.ADDRESS_3, "aijar.address.subcounty", 60, null, true));
        l.add(new AddressComponent(AddressField.ADDRESS_4, "aijar.address.parish", 60, null, true));
        l.add(new AddressComponent(AddressField.ADDRESS_5, "aijar.address.village", 60, null, false));

        return l;
    }

    /**
     * @return the line-by-line format needed by the address template
     */
    @Override
    public List<String> getLineByLineFormat() {
        List<String> l = new ArrayList<String>();
        l.add("country");
        l.add("countyDistrict");
        l.add("stateProvince");
        l.add("address3");
        l.add("address4");
        l.add("address5");
        return l;
    }

    /**
     * @return the location on the classpath from which to load the address hierarchy entries
     */
    @Override
    public String getAddressHierarchyEntryPath() {
        // for each new version rename the file being used see getVersion()
        return "metadata/address_hierarchy_entries_" + getVersion() + ".csv";
    }

    /**
     * You need to increment this every time you commit a new change to the bundle, so that the infrastructure knows
     * whether or not to call #installNewVersion() (based on checking a global property)
     *
     * @return
     */
    @Override
    public int getVersion() {
        return 1;
    }
}
