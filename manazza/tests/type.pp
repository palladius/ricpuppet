class handson::type::test {

    $user_name = 'bob'

    handson::type {$user_name:
        ensure  => present;
    }

    test {'test_for_handson_type': script_name => 'handson/module_handson_test.sh'; }

}

include handson::type::test