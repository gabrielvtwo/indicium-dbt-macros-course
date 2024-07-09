{% macro check_email_regex() %}

    /* 
        This is a more complete example of how we can use a macro as a health check for
        your project.

        In this example, we are using the re python module to match a string to a regex pattern.
        The pattern here is one that recognized emails.
        We are looping through the groups nodes in the manifest.json to check if the email filled
        there is a valid email.
    */

    -- Setting the regex as a string
    {% set regex = "\A[A-Z0-9+_.-]+@[A-Z0-9.-]+\Z" %}

    -- Calling re module (consider this a 'import re' as we would do in Python)
    {% set re = modules.re %}

    -- Let's loop through the graph.groups dictionary
    {% for k, v in graph.groups.items() %}

        -- This is a boolean check. If the regex matches, is_match will return True.
        {% set is_match = re.match(regex, v.owner.email, re.IGNORECASE) %}

        -- If it doesn't match, it will fall behind this if loop...
        {% if not is_match %}

            -- ...and then raise a compiler error with a neat message so the user knows what to do.
            {% do exceptions.raise_compiler_error(
                '
                The following registered email string is not valid: ' ~ v.owner.email ~ '
                
                This error happens at the group: ' ~ v.name ~ '
                '
            ) %}

        {% endif %}

    {% endfor %}

    -- If everything is okay, it will go straight here to a log message for successful executions.
    {% do log("All registered emails are in compliance!", info=true) %}

{% endmacro %}