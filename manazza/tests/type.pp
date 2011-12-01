class manazza::type::test {

    $user_name = 'bob'

    manazza::type {$user_name:
        ensure  => present;
    }

    test {'test_for_manazza_type': script_name => 'manazza/module_manazza_test.sh'; }

}

include manazza::type::test