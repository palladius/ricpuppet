# Installs stuff into a Mac!!
# Convenience component for installing pkg.dmg packages.
define pkg_deploy($sourcedir = false)
{
  $sourcedir_real = $sourcedir ? {
    false => "http://puppet.reductivelabs.foo/osx/pkgs/apps",
    default => $sourcedir
  }
  package { $name:
    ensure => installed,
    provider => pkgdmg,
    source => "$sourcedir_real/$name"
  }
}


class support-workstation {
  case $operatingsystem {
    Darwin: {
      pkg_deploy { "RemoteDesktop-3.0.0-ub.pkg.dmg":
        sourcedir => "http://puppet.reductivelabs.foo/osx/pkgs/apple/ard",
        alias => ard-admin300
      }
      pkg_deploy { "RemoteDesktopAdmin310.dmg":
        sourcedir => "http://puppet.reductivelabs.foo/osx/pkgs/apple/ard",
        require => Package[ard-admin300],
        alias => ard-admin310
      }
      pkg_deploy { "TextMate-1.5.1-01-ub.pkg.dmg": alias => textmate }
    }
  }
}


# Apple updates.
class sw-apple {
  Pkg_deploy { sourcedir => "http://www.math.ohio-state.edu/osx/pkgs/apple/updates_osx" }
  case $hardwaremodel {
    "i386": {
      pkg_deploy { "SecUpd2006-007Intel.dmg": alias => secupd2006-007 }
      pkg_deploy { "SecUpd2006-008Univ.dmg": alias => secupd2006-008, require => Package[secupd2006-007] }
      pkg_deploy { "iChatUpdateUniv.dmg": alias => ichat10 }
      pkg_deploy { "AirPortExtremeUpdate2007001.dmg": alias => airport2007001 }
      pkg_deploy { "SecUpd2007-002Univ.dmg": alias => secupd2007-002, require => Package[secupd2007-001] }
    } # i386:
    "Power Macintosh": {
      pkg_deploy { "SecUpd2006-007Ti.dmg": alias => secupd2006-007 }
      pkg_deploy { "SecUpd2006-008Ti.dmg": alias => secupd2006-008, require => Package[secupd2006-007] }
      pkg_deploy { "iChatUpdatePPC.dmg": alias => ichat10 }
      pkg_deploy { "SecUpd2007-002Ti.dmg": alias => secupd2007-002, require => Package[secupd2007-001] }
    } # powerpc:
  } # case $hardwaremodel
  # The following object are deployed regardless of processor architecture.
  pkg_deploy { "SecUpd2007-001Ti.dmg": alias => secupd2007-001, require => Package[secupd2006-008] }
  pkg_deploy { "DSTUpdateTi-001.dmg": alias => dst_update_tiger }
  pkg_deploy { "JavaForMacOSX10.4Release5.dmg": alias => java_r5 }
  pkg_deploy { "iTunes-7.0.2-1-ub.pkg.dmg": alias => itunes }
  pkg_deploy { "RemoteDesktopClient-3.1.0-1-ub.pkg.dmg": alias => ard-client,
    sourcedir => "http://www.math.ohio-state.edu/osx/pkgs/apple/ard"
  }
}


