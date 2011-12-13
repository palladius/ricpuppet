class manazza::user_with_homedir_and_sshkeys::test {

    $user_name = 'bobtest'

    manazza::user_with_homedir_and_sshkeys {$user_name:
        ensure  => present;
    }

    test {'test_for_manazza_type': script_name => 'manazza/module_manazza_test.sh.erb'; }

}

include manazza::user_with_homedir_and_sshkeys::test