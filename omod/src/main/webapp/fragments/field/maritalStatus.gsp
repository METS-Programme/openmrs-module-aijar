<p>
    <label>
        ${config.label}
        <span>(${ ui.message("emr.formValidation.messages.requiredField.label") })</span>
    </label>
    <select name="${config.formFieldName}">
        <option value="">Select One</option>
        <option value ="90280">0 - Child</option>
        <option value ="1057">1 - Never Married/Single</option>
        <option value ="1060">2 - Living Together</option>
        <option value ="90006">3 - Married</option>
        <option value ="90007">4 - Divorced</option>
        <option value ="90008">5-Separated</option>
        <option value ="90009">6- Widowed</option>
    </select>
    <span class="field-error"></span>
</p>