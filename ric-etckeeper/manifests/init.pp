# Type: etckeeper
#
# This type is a wrapper to allow calls out to test scripts for the module
#
# Parameters:
#   none (we enforce using git)
#
# Actions:
#   Installas etckeeper (TODO rund the initialization script)
#
# Sample Usage:
#   etckeeper
# TODO
# - make it inject the GIT configuration from template
# - run etckeeper init only once 
# - (can rely on fact that aptget install creates file /etc/.etckeeper)

class ric-etckeeper {
  package{ 'etckeeper':
    ensure => present
  }
}
