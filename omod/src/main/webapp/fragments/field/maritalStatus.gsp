<p>
    <label>
        ${config.label}
        <span>(${ ui.message("emr.formValidation.messages.requiredField.label") })</span>
    </label>
    <select name="${config.formFieldName}">
        <option value="">Select One</option>
        <option value ="Child">0 - Child</option>
        <option value ="Single">1 - Never Married/Single</option>
        <option value ="Living Together">2 - Living Together</option>
        <option value ="Married">3 - Married</option>
        <option value ="Divorced">4 - Divorced</option>
        <option value ="Separated">5-Separated</option>
        <option value ="Widowed">6- Widowed</option>
    </select>
    <span class="field-error"></span>
</p>