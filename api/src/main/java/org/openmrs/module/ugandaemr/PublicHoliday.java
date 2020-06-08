package org.openmrs.module.ugandaemr;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.openmrs.BaseOpenmrsData;
import org.springframework.stereotype.Component;

@Component
@Entity(name = "public_holiday")
@Table(name = "public_holiday")
public class PublicHoliday extends BaseOpenmrsData{

    @Id
	@GeneratedValue
	@Column(name = "public_holiday_id")
    private int publicHolidayId;

    @Column(name = "name")
    private String name;

    @Column(name = "public_holiday_date")
    private Date date;

    @Column(name = "description")
    private String description;

    @Override
    public Integer getId() {
        return publicHolidayId;
    }

    @Override
    public void setId(Integer id) {

    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}