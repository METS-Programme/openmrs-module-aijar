<p>
    <label>
        ${config.label}
        <span>(${ui.message("emr.formValidation.messages.requiredField.label")})</span>
    </label>
    <select name="${config.formFieldName}">
        <option value="">Select One</option>
        <option value="dce180a8-30ab-102d-86b0-7a5022ba4115">Child</option>
        <option value="dce180a8-30ab-102d-86b0-7a5022ba4115">Never Married</option>
        %{--<option value ="dcd6da16-30ab-102d-86b0-7a5022ba4115">Single</option>--}%
        <option value="dcd70b18-30ab-102d-86b0-7a5022ba4115">Married</option>
        <option value="dcd743c3-30ab-102d-86b0-7a5022ba4115">Divorced</option>
        <option value="dcd74997-30ab-102d-86b0-7a5022ba4115">Separated</option>
        <option value="dcd77876-30ab-102d-86b0-7a5022ba4115">Widowed</option>
    </select>
    <span class="field-error"></span>
</p>