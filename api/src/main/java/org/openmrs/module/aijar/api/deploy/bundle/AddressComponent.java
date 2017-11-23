package org.openmrs.module.aijar.api.deploy.bundle;

import org.openmrs.module.addresshierarchy.AddressField;

/**
 * Represents a component of a hierarchical address
 */
public class AddressComponent {

    private AddressField field;
    private String nameMapping;
    private int sizeMapping;
    private String elementDefault;
    private boolean requiredInHierarchy;

    public AddressComponent() {
    }

    public AddressComponent(AddressField field, String nameMapping, int sizeMapping, String elementDefault, boolean requiredInHierarchy) {
        this.field = field;
        this.nameMapping = nameMapping;
        this.sizeMapping = sizeMapping;
        this.elementDefault = elementDefault;
        this.requiredInHierarchy = requiredInHierarchy;
    }

    public AddressField getField() {
        return field;
    }

    public void setField(AddressField field) {
        this.field = field;
    }

    public String getNameMapping() {
        return nameMapping;
    }

    public void setNameMapping(String nameMapping) {
        this.nameMapping = nameMapping;
    }

    public int getSizeMapping() {
        return sizeMapping;
    }

    public void setSizeMapping(int sizeMapping) {
        this.sizeMapping = sizeMapping;
    }

    public String getElementDefault() {
        return elementDefault;
    }

    public void setElementDefault(String elementDefault) {
        this.elementDefault = elementDefault;
    }

    public boolean isRequiredInHierarchy() {
        return requiredInHierarchy;
    }

    public void setRequiredInHierarchy(boolean requiredInHierarchy) {
        this.requiredInHierarchy = requiredInHierarchy;
    }
}
