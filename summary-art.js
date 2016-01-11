/**
 * Created by lubwamasamuel on 09/11/2015.
 */
function enable_disable_fm(selected_option){

    var class_name = $j(selected_option).attr("class") ;

    var length = class_name.length;

    var class_id = parseInt(class_name.substring(length-1, length))

    var row_id = class_id;

    var disable = true;

    var row_1 = '[class^="FamilyMember"][class*="Children1"]';
    var row_2 = '[class^="FamilyMember"][class*="Children2"]';
    var row_3 = '[class^="FamilyMember"][class*="Children3"]';
    var row_4 = '[class^="FamilyMember"][class*="Children4"]';
    var row_5 = '[class^="FamilyMember"][class*="Children5"]';

    var xx = row_1;
    var selected_value = $j(selected_option).find(":selected").text()


    switch(selected_value){
        case "P":
        case "Y":
            disable = false;
            break;

    }


    switch(selected_value){
        case "Yes":
            disable = false;
            break;
    }


    switch(row_id){
        case 1:
            xx = row_1;
            break;
        case 2:
            xx = row_2;
            break;
        case 3:
            xx = row_3;
            break;
        case 4:
            xx = row_4;
            break;
        case 5:
            xx = row_5;
            break;
    }


    $j(xx).each(function(){
        var group = $j(this);

        if( class_name.indexOf('Children') == -1)
        {

            group.find("input").attr("disabled",disable );
            group.find('select').attr("disabled",disable );

            //if (disable )
            //group.find("input[type$='text']").val("");


        }
        else if(class_name.indexOf('GrandChildren') == -1) {
            // if (disable )
            // group.find("input[type$='text']").val("");

            group.find("input").attr("disabled",disable );
        }

    });

}

function enable_disable_ei(selected_option){

    var class_name = $j(selected_option).attr("class") ;

    var length = class_name.length;

    var class_id = parseInt(class_name.substring(length-1, length))

    var row_id = class_id;

    var disable = true;

    var row_1 = '[class^="ExposedInfant"][class*="Children1"]';
    var row_2 = '[class^="ExposedInfant"][class*="Children2"]';
    var row_3 = '[class^="ExposedInfant"][class*="Children3"]';
    var row_4 = '[class^="ExposedInfant"][class*="Children4"]';
    var row_5 = '[class^="ExposedInfant"][class*="Children5"]';

    var xx = row_1;
    var selected_value = $j(selected_option).find(":selected").text()

    if (selected_value == "P")
        disable = false;

    switch(row_id){
        case 1:
            xx = row_1;
            break;
        case 2:
            xx = row_2;
            break;
        case 3:
            xx = row_3;
            break;
        case 4:
            xx = row_4;
            break;
        case 5:
            xx = row_5;
            break;
    }


    $j(xx).each(function(){
        var group = $j(this);

        if( class_name.indexOf('Children') == -1)
        {
            group.find("input").attr("disabled",disable );

            //if (disable )
            //group.find("input[type$='text']").val("");

        }

    });

}


function enable_disable_ac(selected_option){

    var class_name = $j(selected_option).attr("class") ;

    var length = class_name.length;

    var class_id = parseInt(class_name.substring(length-1, length))

    var row_id = class_id;

    var disable = true;

    var row_1 = '[class^="ArtCare"][class*="Child1"]';
    var row_2 = '[class^="ArtCare"][class*="Child2"]';
    var row_3 = '[class^="ArtCare"][class*="Child3"]';
    var row_4 = '[class^="ArtCare"][class*="Child4"]';

    var row_5 = '[class^="ArtCare"][class*="Child5"]';
    var row_6 = '[class^="ArtCare"][class*="Child6"]';
    var row_7 = '[class^="ArtCare"][class*="Child7"]';
    var row_8 = '[class^="ArtCare"][class*="Child8"]';

    var row_9 = '[class^="ArtCare"][class*="Child9"]';

    var xx = row_1;
    var selected_value = $j(selected_option).find(":selected").text()

    selected_value = selected_value.trim().toUpperCase();

    if (selected_value == "OTHER")
        disable = false;

    switch(row_id){
        case 1:
            xx = row_1;
            break;
        case 2:
            xx = row_2;
            break;
        case 3:
            xx = row_3;
            break;
        case 4:
            xx = row_4;
            break;

        case 5:
            xx = row_5;
            break;
        case 6:
            xx = row_6;
            break;
        case 7:
            xx = row_7;
            break;
        case 8:
            xx = row_8;
            break;
        case 9:
            xx = row_9;
            break;


    }


    $j(xx).each(function(){
        var group = $j(this);

        if( class_name.indexOf('Child') == -1)
        {
            group.find("input").attr("disabled",disable );

            //if (disable )
            //group.find("input[type$='text']").val("");

        }

    });

}


if(jQuery){
    $j(document).ready(function(){
        if ( $j.browser.msie ) {
            $j(":checkbox").click(function(){
                $j(this).change();
            });
        }

        $j("#comfirmedDate").change(function() {

            alert($(this).find("input[type$='text']").val() );

        });

        $j('[class^="FamilyMemberEnableDisable"]').change(function() {
            enable_disable_fm($j(this));
        });

        $j('[class^="FamilyMemberEnableDisable"]').each(function(){
            enable_disable_fm( $j(this));
        });


        $j('[class^="ExposedInfantEnableDisable"]').change(function() {
            enable_disable_ei($j(this));
        });


        $j('[class^="ArtCareEnableDisable"]').change(function() {
            enable_disable_ac($j(this));
        });


        $j('[class^="ArtCareEnableDisable"]').each(function(){
            enable_disable_ac( $j(this))
        });

        $j(".enableDisable").each(function(){
            var group = $j(this);
            function disableFn(){
                group.children("#disabled").fadeTo(250,1);
                group.children("#disabled").find(":checkbox").attr("checked",false); //uncheck
                // group.children("#disabled").find("input[type$='text']").val("");
                group.children("#disabled").find("input").attr("disabled",true); //disable
                group.children("#disabled").find("select").attr("disabled",true);
            }
            function enableFn(){
                group.children("#disabled").fadeTo(250,1);
                group.children("#disabled").find("input").attr("disabled",false);
                group.children("#disabled").find("select").attr("disabled",false);

            }
            disableFn();
            $j(this).children("#trigger").find(":checkbox:first").change(function(){
                var checked = $(this).attr("checked");
                if(checked == true){
                    enableFn();
                }else{
                    disableFn();
                }
            });
        });


        $j(".checkboxGroup").each(function(){
            var group = $j(this);
            var uncheckAll = function(){
                group.find("input[type$='checkbox']").attr("checked",false);
                group.find("input[type$='checkbox']").change();
            }
            var uncheckRadioAndAll = function(){
                group.find("#checkboxAll,#checkboxRadio").find("input[type$='checkbox']").attr("checked",false);
                group.find("#checkboxAll,#checkboxRadio").find("input[type$='checkbox']").change();
            }


            group.find("#checkboxAll").find("input").click(
                /* This was tricky... A number of things needed to happen
                 Basically, This is supposed to treat a group of inputs as if
                 were all one big checkbox. It is designed so that a checkbox
                 can be next to an input, and the user clicks the input, the
                 checkbox checks as well. But, when the user clicks the checkbox,
                 the browser marks the checkbox as checked. Therefore, when we check
                 if the checkbox is already checked, it always respondes true...
                 We needed to have 2 cases: when the clicking action is on the first checkbox
                 and when the action is on any other. */
                function(){
                    var flip;
                    var checked = $j(this).siblings(":checkbox:first").attr("checked");
                    if($j(this).attr("name") == $j(this).parents("#checkboxAll:first").find(":checkbox:first").attr("name")){
                        checked = $(this).attr("checked");
                        flip = checked;
                    }else{
                        flip = !checked;
                    }
                    if($j.attr("type") == "text") if(flip == false) flip = !filp; // this is so the user doesn't go to check the checkbox, then uncheck it when they hit the input.
                    uncheckAll();
                    $j(this).parents("#checkboxAll:first").find(":checkbox").attr("checked",flip);
                    $j(this).parents("#checkboxAll:first").find(":checkbox").change();
                }
            );


            group.find("#checkboxRadio").find("input[type$='checkbox']").click(function(){
                uncheckAll();
                $j(this).siblings("input[type$='checkbox']").attr("checked",false);
                $j(this).attr("checked",true);
                $j(this).change();
            });

            group.find("#checkboxCheckbox").click(
                function(){
                    uncheckRadioAndAll();
                }
            );
        });
    });
}