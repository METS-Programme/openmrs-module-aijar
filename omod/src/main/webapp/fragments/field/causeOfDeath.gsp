<fieldset>
    <legend id="deceasedLabel">${config.label}</legend>

    <h3>${ui.message("aijar.registrationapp.deceased.question")}</h3>

    <p>
        <input id="checkbox-deceased" type="checkbox"/>
        <label for="checkbox-deceased">${ui.message("aijar.registrationapp.deceased.label")}</label>
    </p>
<p>
    <label for="deceased-status">
        ${config.label}
        <span>(${ ui.message("emr.formValidation.messages.requiredField.label") })</span>
    </label>
    <select name="${config.formFieldName}" id="deceased-status">
        <option value ="dcd6865a-30ab-102d-86b0-7a5022ba4115">Unknown</option>
        <option value ="db6dc4d4-432d-44e0-a4c1-0b414d3cc639">Disease</option>
        <option value ="46d2a442-6249-455e-a278-4df8cd8a6a8e">Accident</option>
    </select>
    <span class="field-error"></span>
</p>
</fieldset>