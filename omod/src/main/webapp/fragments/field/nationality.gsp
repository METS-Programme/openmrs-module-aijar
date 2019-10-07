<p>
    <label>
        ${config.label}
        <span>(${ ui.message("emr.formValidation.messages.requiredField.label") })</span>
    </label>
    <select name="${config.formFieldName}">
        <option value="">Select One</option>
        <option value ="National">National</option>
        <option value ="Foreigner">Foreigner</option>
        <option value ="Refugee">Refugee</option>
    </select>
    <span class="field-error"></span>
</p>