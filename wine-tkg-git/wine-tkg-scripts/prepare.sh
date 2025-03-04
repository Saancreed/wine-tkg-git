#!/bin/bash

_exit_cleanup() {
  if [ "$pkgver" != "0" ]; then
    sed -i "s/pkgver=$pkgver.*/pkgver=0/g" "$_where"/PKGBUILD
  fi

  # Proton-tkg specifics to send to token
  if [ -e "$_where"/BIG_UGLY_FROGMINER ] && [ "$_EXTERNAL_INSTALL" = "proton" ] && [ -n "$_proton_tkg_path" ]; then
    if [ -n "$_PROTON_NAME_ADDON" ]; then
      if [ "$_ispkgbuild" = "true" ]; then
        echo "_protontkg_version='makepkg.${_PROTON_NAME_ADDON}'" >> "$_proton_tkg_path"/proton_tkg_token
        echo "_protontkg_true_version='${pkgver}.${_PROTON_NAME_ADDON}'" >> "$_proton_tkg_path"/proton_tkg_token
      else
        echo "_protontkg_version='${pkgver}.${_PROTON_NAME_ADDON}'" >> "$_proton_tkg_path"/proton_tkg_token
      fi
    else
      if [ "$_ispkgbuild" = "true" ]; then
        echo "_protontkg_version=makepkg" >> "$_proton_tkg_path"/proton_tkg_token
        echo "_protontkg_true_version='${pkgver}'" >> "$_proton_tkg_path"/proton_tkg_token
      else
        echo "_protontkg_version='${pkgver}'" >> "$_proton_tkg_path"/proton_tkg_token
      fi
    fi
    if [[ $pkgver = 3.* ]]; then
      echo '_proton_branch="proton_3.16"' >> "$_proton_tkg_path"/proton_tkg_token
    elif [[ $pkgver = 4.* ]]; then
      echo '_proton_branch="proton_4.11"' >> "$_proton_tkg_path"/proton_tkg_token
    else
      echo "_proton_branch=${_proton_branch}" >> "$_proton_tkg_path"/proton_tkg_token
    fi
    if [ -n "$_proton_dxvk_configfile" ]; then
      echo "_proton_dxvk_configfile=${_proton_dxvk_configfile}" >> "$_proton_tkg_path"/proton_tkg_token
    fi
    if [ -n "$_proton_dxvk_hud" ]; then
      echo "_proton_dxvk_hud=${_proton_dxvk_hud}" >> "$_proton_tkg_path"/proton_tkg_token
    fi
    echo "_skip_uninstaller=${_skip_uninstaller}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_no_autoinstall=${_no_autoinstall}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_pkg_strip=${_pkg_strip}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_nvapi_disable=${_proton_nvapi_disable}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_winedbg_disable=${_proton_winedbg_disable}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_conhost_disable=${_proton_conhost_disable}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_pulse_lowlat=${_proton_pulse_lowlat}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_force_LAA=${_proton_force_LAA}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_shadercache_path=${_proton_shadercache_path}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_winetricks=${_proton_winetricks}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_dxvk_async=${_proton_dxvk_async}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_use_steamhelper=${_proton_use_steamhelper}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_mf_hacks=${_proton_mf_hacks}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_dxvk_dxgi=${_dxvk_dxgi}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_use_dxvk=${_use_dxvk}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_dxvk_version=${_dxvk_version}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_use_vkd3dlib='${_use_vkd3dlib}'" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_pkgdest='${pkgdir}'" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_branch_exp='${_proton_branch_exp}'" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_steamvr_support='${_steamvr_support}'" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_NUKR='${_NUKR}'" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_winesrcdir='${_winesrcdir}'" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_standard_dlopen='${_standard_dlopen}'" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_no_loader_array='${_no_loader_array}'" >> "$_proton_tkg_path"/proton_tkg_token
    echo "CUSTOM_MINGW_PATH='${CUSTOM_MINGW_PATH}'" >> "$_proton_tkg_path"/proton_tkg_token
    echo "CUSTOM_GCC_PATH='${CUSTOM_GCC_PATH}'" >> "$_proton_tkg_path"/proton_tkg_token
    if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 1e478b804f72a9b5122fc6adafac5479b816885e HEAD ) && [ "$_dxvk_minimald3d10" != "false" ]; then
      echo "_dxvk_minimald3d10='true'" >> "$_proton_tkg_path"/proton_tkg_token
    fi
    echo "_build_mediaconv='${_build_mediaconv}'" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_build_gstreamer='${_build_gstreamer}'" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_lib32_gstreamer='${_lib32_gstreamer}'" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_build_faudio='${_build_faudio}'" >> "$_proton_tkg_path"/proton_tkg_token
  fi

  rm -f "$_where"/BIG_UGLY_FROGMINER && msg2 'Removed BIG_UGLY_FROGMINER - Ribbit' # state tracker end

  if [ "$_NUKR" = "true" ]; then
    # Sanitization
    rm -rf "$srcdir"/"$_esyncsrcdir"
    rm -rf "$srcdir"/*.patch
    rm -rf "$srcdir"/*.tgz
    rm -rf "$srcdir"/*.conf
    rm -f "$srcdir"/wine-tkg
    rm -f "$srcdir"/wine-tkg-interactive
    rm -f "$_where"/proton_tkg_token && msg2 'Removed Proton-tkg token - Valve Ribbit' # state tracker end
    msg2 'exit cleanup done'
  fi

  # Remove temporarily copied patches & other potential fluff
  rm -f "$_where"/wine-tkg
  rm -f "$_where"/wine-tkg-interactive
  rm -f "$_where"/wine-tkg.install
  rm -rf "$_where"/*.patch
  rm -rf "$_where"/*.my*
  rm -rf "$_where"/*.conf
  rm -rf "$_where"/*.orig
  rm -rf "$_where"/*.rej

  if [ -n "$_buildtime64" ]; then
    msg2 "Compilation time for 64-bit wine: \n$_buildtime64\n"
  fi
  if [ -n "$_buildtime32" ]; then
    msg2 "Compilation time for 32-bit wine: \n$_buildtime32\n"
  fi
}

_cfgstring() {
  if [[ "$_cfgstringin" = /home/* ]]; then
    _cfgstringout="~/$( echo $_cfgstringin | cut -d'/' -f4-)"
  else
    _cfgstringout="$_cfgstringin"
  fi
}

update_configure() {
  _file="./configure"

  if ! cp -a "$_file" "$_file.old"; then
    abort "failed to create $_file.old"
  fi

  if ! autoreconf -f; then
    rm "$_file.old"
    unset _file
    return 1
  fi

  # This is undefined behaviour when off_t is 32-bit, see https://launchpad.net/ubuntu/+source/autoconf/2.69-6
  # GE has reported RDR2 online issues with the fix applied (which staging applies), so let's restore the broken ways
  sed -i'' -e "s|^#define LARGE_OFF_T ((((off_t) 1 << 31) << 31) - 1 + (((off_t) 1 << 31) << 31))\$|#define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))|g" "$_file"
  sed -i'' -e "s|^#define LARGE_OFF_T (((off_t) 1 << 31 << 31) - 1 + ((off_t) 1 << 31 << 31))\$|#define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))|g" "$_file"
  unset _large_off_old _large_off_new

  # Restore original timestamp when nothing changed
  if ! cmp "$_file.old" "$_file" >/dev/null; then
    rm "$_file.old"
  else
    mv "$_file.old" "$_file"
  fi

  unset _file
  return 0
}

_init() {
msg2 '       .---.`               `.---.'
msg2 '    `/syhhhyso-           -osyhhhys/`'
msg2 '   .syNMdhNNhss/``.---.``/sshNNhdMNys.'
msg2 '   +sdMh.`+MNsssssssssssssssNM+`.hMds+'
msg2 '   :syNNdhNNhssssssssssssssshNNhdNNys:'
msg2 '    /ssyhhhysssssssssssssssssyhhhyss/'
msg2 '    .ossssssssssssssssssssssssssssso.'
msg2 '   :sssssssssssssssssssssssssssssssss:'
msg2 '  /sssssssssssssssssssssssssssssssssss/'
msg2 ' :sssssssssssssoosssssssoosssssssssssss:'
msg2 ' osssssssssssssoosssssssoossssssssssssso'
msg2 ' osssssssssssyyyyhhhhhhhyyyyssssssssssso'
msg2 ' /yyyyyyhhdmmmmNNNNNNNNNNNmmmmdhhyyyyyy/'
msg2 '  smmmNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmmms'
msg2 '   /dNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNd/'
msg2 '    `:sdNNNNNNNNNNNNNNNNNNNNNNNNNds:`'
msg2 '       `-+shdNNNNNNNNNNNNNNNdhs+-`'
msg2 '             `.-:///////:-.`'
msg2 ''

  # load default configuration from files
  if [ -e "$_where"/proton_tkg_token ]; then
    source "$_where"/proton_tkg_token
    source "$_proton_tkg_path"/proton-tkg.cfg
    source "$_proton_tkg_path"/proton-tkg-profiles/advanced-customization.cfg
  else
    source "$_where"/customization.cfg
    source "$_where"/wine-tkg-profiles/advanced-customization.cfg
    _EXTERNAL_INSTALL_TYPE="opt"
  fi

  # Load external configuration file if present. Available variable values will overwrite customization.cfg ones.
  if [ -e "$_EXT_CONFIG_PATH" ]; then
    source "$_EXT_CONFIG_PATH" && msg2 "External configuration file $_EXT_CONFIG_PATH will be used to override customization.cfg values." && msg2 ""
  fi

  if [ "$_NOINITIALPROMPT" = "true" ] || [ -n "$_LOCAL_PRESET" ] || [ -n "$_DEPSHELPER" ]; then
    msg2 'Initial prompt skipped. Do you remember what it said? 8)'
  else
    # If the state tracker isn't found, prompt the user with useful stuff.
    # This is to prevent the prompt to come back until packaging is done
    if [ ! -e "$_where"/BIG_UGLY_FROGMINER ]; then
      msg2 '#################################################################'
      msg2 ''
      msg2 'You can configure your wine build flavour (right now for example)'
      if [ -e "$_EXT_CONFIG_PATH" ]; then
        msg2 "by editing the $_EXT_CONFIG_PATH file."
        msg2 ''
        msg2 'In case you are only using a partial config file, remaining'
        msg2 'values will be loaded from the .cfg file next to this script !'
      elif [ -e "$_proton_tkg_path"/proton_tkg_token ]; then
        msg2 'by editing the proton-tkg.cfg file in the proton-tkg dir,'
        msg2 'or by creating a custom config, for example'
        msg2 '~/.config/frogminer/proton-tkg.cfg (path set in config file)'
        msg2 'to override some or all of its values.'
      else
        msg2 'by editing the customization.cfg file next to this PKGBUILD,'
        msg2 'or by creating a custom config, for example'
        msg2 '~/.config/frogminer/wine-tkg.cfg (path set in config file)'
        msg2 'to override some or all of its values.'
      fi
      msg2 ''
      msg2 "Current path is '$_where'"
      msg2 ''
      msg2 'If you are rebuilding using the same configuration, you may want'
      msg2 'to delete/move previously built package if in the same dir.'
      msg2 ''
      msg2 '###################################TkG##########was##########here'
      read -rp "When you are ready, press enter to continue."

      if [ -e "$_EXT_CONFIG_PATH" ]; then
        source "$_EXT_CONFIG_PATH" && msg2 "External config loaded" # load external configuration from file again, in case of changes.
      else
        # load default configuration from file again, in case of change
        if [ -e "$_proton_tkg_path"/proton_tkg_token ]; then
          source "$_proton_tkg_path"/proton-tkg.cfg
          source "$_proton_tkg_path"/proton-tkg-profiles/advanced-customization.cfg
        else
          source "$_where"/customization.cfg
          source "$_where"/wine-tkg-profiles/advanced-customization.cfg
        fi
      fi
    fi
  fi

  # Load preset configuration files if present and selected. All values will overwrite customization.cfg ones.
  if [ -n "$_LOCAL_PRESET" ] && [ -e "$_where"/wine-tkg-profiles/wine-tkg-"$_LOCAL_PRESET".cfg ]; then
    source "$_where"/wine-tkg-profiles/wine-tkg.cfg && source "$_where"/wine-tkg-profiles/wine-tkg-"$_LOCAL_PRESET".cfg && msg2 "Preset configuration $_LOCAL_PRESET will be used to override customization.cfg values." && msg2 ""
  fi

  # Check for proton-tkg token to prevent broken state as we need to enforce some defaults
  if [ -e "$_proton_tkg_path"/proton_tkg_token ] && [ -n "$_proton_tkg_path" ]; then
    _LOCAL_PRESET=""
    _EXTERNAL_INSTALL="proton"
    _EXTERNAL_NOVER="false"
    _nomakepkg_nover="true"
    _NOLIB32="false"
    _NOLIB64="false"
    _esync_version=""
    _use_faudio="true"
    _highcorecount_fix="true"
    _use_mono="true"
    if [ "$_use_dxvk" = "true" ] || [ "$_use_dxvk" = "release" ]; then
      _use_dxvk="release"
      _dxvk_dxgi="true"
    fi
    #if [ "$_ispkgbuild" = "true" ]; then
    #  _steamvr_support="false"
    #fi
    if [ "$_use_latest_mono" = "true" ]; then
      if ! [ -f "$_where"/$( curl -s https://api.github.com/repos/madewokherd/wine-mono/releases/latest | grep "browser_download_url.*x86.msi" | cut -d : -f 2,3 | tr -d \" | sed -e "s|.*/||") ]; then
        rm -f "$_where"/wine-mono* # Remove any existing older mono
        msg2 "Downloading latest mono..."
        ( curl -s https://api.github.com/repos/madewokherd/wine-mono/releases/latest | grep "browser_download_url.*x86.msi" | cut -d : -f 2,3 | tr -d \" | wget -qi - )
      fi
    fi
  elif [ "$_EXTERNAL_INSTALL" = "proton" ]; then
    error "It looks like you're attempting to build a Proton version of wine-tkg-git."
    error "This special option doesn't use pacman and requires you to run 'proton-tkg.sh' script from proton-tkg dir."
    _exit_cleanup
    exit
  fi
  # Disable undesirable patchsets when using official proton wine source
  if [ "$_custom_wine_source" = "https://github.com/ValveSoftware/wine" ]; then
    _clock_monotonic="false"
    _FS_bypass_compositor="false"
    _use_esync="false"
    _use_fsync="false"
    _use_staging="false"
    _proton_fs_hack="false"
    _large_address_aware="false"
    _proton_mf_hacks="false"
    _update_winevulkan="false"
    _mtga_fix="false"
    _protonify="false"
    _childwindow_fix="false"
    _unfrog="true"
  fi
}

_pkgnaming() {
  if [ -n "$_PKGNAME_OVERRIDE" ]; then
    if [ "$_PKGNAME_OVERRIDE" = "none" ]; then
      pkgname="${pkgname}"
    else
      pkgname="${pkgname}-${_PKGNAME_OVERRIDE}"
    fi
    msg2 "Overriding default pkgname. New pkgname: ${pkgname}"
  else
    if [ "$_use_staging" = "true" ]; then
      pkgname="${pkgname/%-git/-staging-git}"
      msg2 "Using staging patchset"
    fi

    if [ "$_use_esync" = "true" ]; then
      if [ "$_use_fsync" = "true" ]; then
        pkgname="${pkgname/%-git/-fsync-git}"
        msg2 "Using fsync patchset"
      else
        pkgname="${pkgname/%-git/-esync-git}"
        msg2 "Using esync patchset"
      fi
    fi

    if [ "$_use_pba" = "true" ]; then
#      pkgname="${pkgname/%-git/-pba-git}"
      msg2 "Using pba patchset"
    fi

    if [ "$_use_legacy_gallium_nine" = "true" ]; then
      pkgname="${pkgname/%-git/-nine-git}"
      msg2 "Using gallium nine patchset (legacy)"
    fi
  fi

  # External install
  if [ "$_EXTERNAL_INSTALL" = "true" ]; then
    pkgname="${pkgname/%-git/-$_EXTERNAL_INSTALL_TYPE-git}"
    msg2 "Installing to $_DEFAULT_EXTERNAL_PATH/$pkgname"
  elif [ "$_EXTERNAL_INSTALL" = "proton" ]; then
    pkgname="proton_dist"
    _DEFAULT_EXTERNAL_PATH="$HOME/.steam/root/compatibilitytools.d"
    if [ "$_ispkgbuild" != "true" ]; then
      msg2 "Installing to $_DEFAULT_EXTERNAL_PATH/proton_tkg"
    fi
  fi
}

user_patcher() {
	# To patch the user because all your base are belong to us
	local _patches=("$_where"/*."${_userpatch_ext}revert")
	if [ ${#_patches[@]} -ge 2 ] || [ -e "${_patches}" ]; then
	  if [ "$_user_patches_no_confirm" != "true" ]; then
	    msg2 "Found ${#_patches[@]} 'to revert' userpatches for ${_userpatch_target}:"
	    printf '%s\n' "${_patches[@]}"
	    read -rp "Do you want to install it/them? - Be careful with that ;)"$'\n> N/y : ' _CONDITION;
	  fi
	  if [[ "$_CONDITION" =~ [yY] ]] || [ "$_user_patches_no_confirm" = "true" ]; then
	    for _f in ${_patches[@]}; do
	      if [ -e "${_f}" ]; then
	        msg2 "######################################################"
	        msg2 ""
	        msg2 "Reverting your own ${_userpatch_target} patch ${_f}"
	        msg2 ""
	        msg2 "######################################################"
	        echo -e "\nReverting your own patch ${_f##*/}" >> "$_where"/prepare.log
	        if ! patch -Np1 -R < "${_f}" >> "$_where"/prepare.log; then
	          error "Patch application has failed. The error was logged to $_where/prepare.log for your convenience."
	          if [ -n "$_last_known_good_mainline" ] || [ -n "$_last_known_good_staging" ]; then
	            msg2 "To use the last known good mainline version, please set _plain_version=\"$_last_known_good_mainline\" in your .cfg"
	            msg2 "To use the last known good staging version, please set _staging_version=\"$_last_known_good_staging\" in your .cfg (requires _use_staging=\"true\")"
	          fi
	          exit 1
	        fi
	        echo -e "Reverted your own patch ${_f##*/}" >> "$_where"/last_build_config.log
	      fi
	    done
	  fi
	fi

	_patches=("$_where"/*."${_userpatch_ext}patch")
	if [ ${#_patches[@]} -ge 2 ] || [ -e "${_patches}" ]; then
	  if [ "$_user_patches_no_confirm" != "true" ]; then
	    msg2 "Found ${#_patches[@]} userpatches for ${_userpatch_target}:"
	    printf '%s\n' "${_patches[@]}"
	    read -rp "Do you want to install it/them? - Be careful with that ;)"$'\n> N/y : ' _CONDITION;
	  fi
	  if [[ "$_CONDITION" =~ [yY] ]] || [ "$_user_patches_no_confirm" = "true" ]; then
	    for _f in ${_patches[@]}; do
	      if [ -e "${_f}" ]; then
	        msg2 "######################################################"
	        msg2 ""
	        msg2 "Applying your own ${_userpatch_target} patch ${_f}"
	        msg2 ""
	        msg2 "######################################################"
	        echo -e "\nApplying your own patch ${_f##*/}" >> "$_where"/prepare.log
	        if ! patch -Np1 < "${_f}" >> "$_where"/prepare.log; then
	          error "Patch application has failed. The error was logged to $_where/prepare.log for your convenience."
	          if [ -n "$_last_known_good_mainline" ] || [ -n "$_last_known_good_staging" ]; then
	            msg2 "To use the last known good mainline version, please set _plain_version=\"$_last_known_good_mainline\" in your .cfg"
	            msg2 "To use the last known good staging version, please set _staging_version=\"$_last_known_good_staging\" in your .cfg (requires _use_staging=\"true\")"
	          fi
	          exit 1
	        fi
	        echo -e "Applied your own patch ${_f##*/}" >> "$_where"/last_build_config.log
	      fi
	    done
	  fi
	fi
}

_describe_wine() {
  git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//;s/\.rc/rc/;s/^wine\.//'
}

_describe_other() {
  git describe --long --tags --always | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//'
}

_committer() {
  if [ "$_generate_patchsets" != "false" ]; then
    ( git add . && git commit -m "$_commitmsg" && git format-patch -n HEAD^ || true ) >/dev/null 2>&1
  fi
}

_source_cleanup() {
	if [ "$_NUKR" != "debug" ]; then
	  if [ "$_use_staging" = "true" ]; then
	    cd "${srcdir}"/"${_stgsrcdir}"

	    # restore the targetted trees to their git origin state
	    # for the patches not to fail on subsequent aborted builds
	    msg2 'Cleaning wine-staging source code tree...'
	    git reset --hard HEAD 	# restore tracked files
	    git clean -xdf 			# delete untracked files
	  fi

	  cd "${srcdir}"/"${_winesrcdir}"

	  msg2 'Cleaning wine source code tree...'
	  git reset --hard HEAD 	# restore tracked files
	  git clean -xdf 			# delete untracked files
	fi
}

_prepare() {
	# holds extra arguments to staging's patcher script, if applicable
	local _staging_args=()

	source "$_where"/wine-tkg-patches/hotfixes/earlyhotfixer

	# grabs userdefined staging args if any
	_staging_args+=($_staging_userargs)

	if [ "$_use_staging" = "true" ] && [ "$_staging_upstreamignore" != "true" ]; then
	  cd "${srcdir}"/"${_winesrcdir}"
	  # change back to the wine upstream commit that this version of wine-staging is based in
	  msg2 'Changing wine HEAD to the wine-staging base commit...'
	  git checkout "$(../"$_stgsrcdir"/patches/patchinstall.sh --upstream-commit)"
	fi

	# Community patches
	if [ -n "$_community_patches" ]; then
	  if [ ! -d "$_where/../../community-patches" ] && [ ! -d "$_where/../community-patches" ]; then
	    { cd "$_where/../.."
	      git clone https://github.com/Frogging-Family/community-patches.git
	      _community_patches_repo_path="$_where/../../community-patches/wine-tkg-git"
	    } || {
	      msg2 "Cloning the community-patches repo inside the wine-tkg-git dir due to permission limitations in the current path.."
	      cd "$_where/.."
	      git clone https://github.com/Frogging-Family/community-patches.git
	      _community_patches_repo_path="$_where/../community-patches/wine-tkg-git"
	    }
	    cd "${srcdir}"/"${_winesrcdir}"
	  elif [ -d "$_where/../../community-patches" ]; then
	    _community_patches_repo_path="$_where/../../community-patches/wine-tkg-git"
	  elif [ -d "$_where/../community-patches" ]; then
	    _community_patches_repo_path="$_where/../community-patches/wine-tkg-git"
	  fi
	  _community_patches=($_community_patches)
	  ( msg2 "Updating community patches repo..." && cd "$_community_patches_repo_path" && git pull origin master )
	  for _p in ${_community_patches[@]}; do
	    if [ -e "$_community_patches_repo_path/$_p" ]; then
	      ln -s "$_community_patches_repo_path/$_p" "$_where"/
	    else
	      warning "The requested community patch \"$_p\" wasn't found in the community-patches repo."
	      msg2 "You can check https://github.com/Frogging-Family/community-patches.git for available patches."
	    fi
	  done
	fi

	# output config to logfile
	echo "# Last $pkgname configuration - $(date) :" > "$_where"/last_build_config.log
	echo "" >> "$_where"/last_build_config.log

	# log config file in use
	if [ -n "$_LOCAL_PRESET" ] && [ -e "$_where"/wine-tkg-profiles/wine-tkg-"$_LOCAL_PRESET".cfg ]; then
	  _cfgstringin="$_LOCAL_PRESET" && _cfgstring && echo "Local preset configuration file $_cfgstringout used" >> "$_where"/last_build_config.log
	elif [ -n "$_EXT_CONFIG_PATH" ] && [ -e "$_EXT_CONFIG_PATH" ]; then
	  _cfgstringin="$_EXT_CONFIG_PATH" && _cfgstring && echo "External configuration file $_cfgstringout used" >> "$_where"/last_build_config.log
	else
	  echo "Local cfg files used" >> "$_where"/last_build_config.log
	fi

	if [ "$_nomakepkg_midbuild_prompt" = "true" ]; then
	  echo "You will be prompted after the 64-bit side is built (compat workaround)" >> "$_where"/last_build_config.log
	fi

	_realwineversion=$(_describe_wine)
	echo "" >> "$_where"/last_build_config.log
	echo "Wine (plain) version: $_realwineversion" >> "$_where"/last_build_config.log

	if [ "$_use_staging" = "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  _realwineversion=$(_describe_wine)
	  echo "Using wine-staging patchset (version $_realwineversion)" >> "$_where"/last_build_config.log
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	echo "" >> "$_where"/last_build_config.log
	echo -e "*.patch\n*.orig\n*~\n.gitignore\nautom4te.cache/*" > "${srcdir}"/"${_winesrcdir}"/.gitignore

	# Disable local Esync on 553986f
	if [ "$_use_staging" = "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  if git merge-base --is-ancestor 553986fdfb111914f793ff1487d53af022e4be19 HEAD; then # eventfd_synchronization: Add patch set.
	    _use_esync="false"
	    _staging_esync="true"
	    echo "Disabled the local Esync patchset to use Staging impl instead." >> "$_where"/last_build_config.log
	  fi
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	if [ "$_use_esync" = "true" ]; then
	  if [ -z "$_esync_version" ]; then
	    if git merge-base --is-ancestor 2600ecd4edfdb71097105c74312f83845305a4f2 HEAD; then # 3.20+
	      _esync_version="ce79346"
	    elif git merge-base --is-ancestor aec7befb5115d866724149bbc5576c7259fef820 HEAD; then # 3.19-3.17
	      _esync_version="b4478b7"
	    else
	      _esync_version="5898a69" # 3.16 and lower
	    fi
	  fi
	  echo "Using esync patchset (version ${_esync_version})" >> "$_where"/last_build_config.log
	  wget -O "$_where"/esync"${_esync_version}".tgz https://github.com/zfigura/wine/releases/download/esync"${_esync_version}"/esync.tgz && tar zxf "$_where"/esync"${_esync_version}".tgz -C "${srcdir}"
	fi

	if [ "$_use_pba" = "true" ]; then
	  # If using a wine version that includes 944e92b, disable PBA
	  if git merge-base --is-ancestor 944e92ba06ecadeb933d95e30035323483dfe7c7 HEAD; then # wined3d: Pass the wined3d_buffer_desc structure directly to buffer_init()
	    _pba_version="none"
	  # If using a wine version that includes 580ea44, apply 3.17+ fixes
	  elif git merge-base --is-ancestor 580ea44bc65472c0304d74b7e873acfb7f680b85 HEAD; then # wined3d: Use query buffer objects for occlusion queries
	    _pba_version="317+"
	  # If using a wine version that includes cf9536b, apply 3.14+ fixes
	  elif git merge-base --is-ancestor cf9536b6bfbefbf5003c7633446a91f6e399c4de HEAD; then # wined3d: Move OpenGL initialisation code to adapter_gl.c
	    _pba_version="314+"
	  else
	    _pba_version="313-"
	  fi
	fi

	if [ "$_use_legacy_gallium_nine" = "true" ]; then
	  echo "Using gallium nine patchset (legacy)" >> "$_where"/last_build_config.log
	fi

	if [ "$_use_vkd3dlib" != "true" ]; then
	  echo "Not using vkd3d native library for d3d12 translation (allows using vkd3d-proton)" >> "$_where"/last_build_config.log
	fi

	# mingw-w64-gcc
	if [ "$_NOMINGW" = "true" ]; then
	  echo "Not using MinGW-gcc for building" >> "$_where"/last_build_config.log
	fi

	echo "" >> "$_where"/last_build_config.log

	if [ "$_NUKR" = "debug" ]; then
	  msg2 "You are currently in debug/dev mode. By default, patches aren't applied in this mode as the source won't be cleaned up/reset between compilations. You can however choose to patch your tree to get your initial source as you desire:"
	  read -rp "Do you want to patch the current wine source with the builtin patches (respecting your .cfg settings)? Do it only once or patches will fail!"$'\n> N/y : ' _DEBUGANSW1;
	  if [ "$_use_staging" = "true" ]; then
	    read -rp "Do you want to patch the current wine source with staging patches (respecting your .cfg settings)? Do it only once or patches will fail!"$'\n> N/y : ' _DEBUGANSW2;
	  fi
	  read -rp "Do you want to run configure? You need to run it at least once to populate your build dirs!"$'\n> N/y : ' _DEBUGANSW3;
	fi

	# Reverts
	nonuser_reverter() {
	  if [ "$_NUKR" != "debug" ] && [ "$_unfrog" != "true" ] || [[ "$_DEBUGANSW1" =~ [yY] ]]; then
	    if git merge-base --is-ancestor $_committorevert HEAD; then
	      echo -e "\n$_committorevert reverted $_hotfixmsg" >> "$_where"/prepare.log
	      git revert -n --no-edit $_committorevert >> "$_where"/prepare.log || (error "Patch application has failed. The error was logged to $_where/prepare.log for your convenience."; msg2 "To use the last known good mainline version, please set _plain_version=\"$_last_known_good_mainline\" in your .cfg"; msg2 "To use the last known good staging version, please set _staging_version=\"$_last_known_good_staging\" in your .cfg (requires _use_staging=\"true\")" && exit 1)
	      if [ "$_hotfixmsg" != "(hotfix)" ] && [ "$_hotfixmsg" != "(staging hotfix)" ]; then
	        echo -e "$_committorevert reverted $_hotfixmsg" >> "$_where"/last_build_config.log
	      fi
	    fi
	  fi
	}

	# Hotfixer
	if [ "$_LOCAL_PRESET" != "staging" ] && [ "$_LOCAL_PRESET" != "mainline" ] && [ "$_NUKR" != "debug" ] && [ "$_unfrog" != "true" ] || [[ "$_DEBUGANSW1" =~ [yY] ]]; then
	  source "$_where"/wine-tkg-patches/hotfixes/hotfixer
	  msg2 "Hotfixing..."
	  for _commit in ${_hotfix_mainlinereverts[@]}; do
	    cd "${srcdir}"/"${_winesrcdir}"
	    _committorevert=$_commit _hotfixmsg="(hotfix)" nonuser_reverter
	    cd "${srcdir}"/"${_winesrcdir}"
	  done
	  for _commit in ${_hotfix_stagingreverts[@]}; do
	    cd "${srcdir}"/"${_stgsrcdir}"
	    _committorevert=$_commit _hotfixmsg="(staging hotfix)" nonuser_reverter
	    cd "${srcdir}"/"${_winesrcdir}"
	  done
	  echo -e "Done applying reverting hotfixes (if any) - list available in prepare.log" >> "$_where"/last_build_config.log
	fi

	echo "" >> "$_where"/last_build_config.log

	if [ "$_mtga_fix" = "true" ] && git merge-base --is-ancestor e5a9c256ce08868f65ed730c00cf016a97369ce3 HEAD && ! git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD; then
	  _committorevert=341068aa61a71afecb712feda9aabb3dc1c3ab5f && nonuser_reverter
	  _committorevert=e5a9c256ce08868f65ed730c00cf016a97369ce3 && nonuser_reverter
	  echo -e "( MTGA bandaid reverts applied )\n" >> "$_where"/last_build_config.log
	fi

	if [ "$_sdl_joy_support" = "true" ] && [ "$_use_staging" != "true" ] && [ "$_EXTERNAL_INSTALL" = "proton" ] && git merge-base --is-ancestor e4fbae832c868e9fcf5a91c58255fe3f4ea1cb30 HEAD && ! git merge-base --is-ancestor a17367291104e46c573b7213ee94a0f537563ace HEAD; then
	  _committorevert=e4fbae832c868e9fcf5a91c58255fe3f4ea1cb30 && nonuser_reverter
	  echo -e "( Proton SDL Joystick support unbreak revert applied )\n" >> "$_where"/last_build_config.log
	fi
	if [ "$_gamepad_additions" = "true" ] && [ "$_use_staging" = "true" ] && [ "$_EXTERNAL_INSTALL" = "proton" ] && git merge-base --is-ancestor da7d60bf97fb8726828e57f852e8963aacde21e9 HEAD && ! git merge-base --is-ancestor 6373792eec0f122295723cae77b0115e6c96c3e4 HEAD; then
	  _committorevert=da7d60bf97fb8726828e57f852e8963aacde21e9 && nonuser_reverter
	  echo -e "( Proton gamepad additions unbreak revert applied )\n" >> "$_where"/last_build_config.log
	fi

	if [ "$_warframelauncher_fix" = "true" ] && git merge-base --is-ancestor 5e218fe758fe6beed5c7ad73405eccf33c307e6d HEAD && ! git merge-base --is-ancestor adfb042819472a23f4d07f7aeea194e463855806 HEAD; then
	  _committorevert=bae4776c571cf975be1689594f4caf93ad23e0ca && nonuser_reverter
	  _committorevert=5e218fe758fe6beed5c7ad73405eccf33c307e6d && nonuser_reverter
	  echo -e "( Warframe Launcher unbreak reverts applied )\n" >> "$_where"/last_build_config.log
	fi

	if [ "$_proton_fs_hack" = "true" ]; then
	  if ! git merge-base --is-ancestor aee91dc4ac08428e74fbd21f97438db38f84dbe5 HEAD; then
	    _committorevert=427152ec7b4ee85631617b693dbf1deea763c0ba && nonuser_reverter
	    _committorevert=b7b4bacaf99661e07c2f07a0260680b4e8bed4f8 && nonuser_reverter
	    _committorevert=acf03ed9da0f7d3f94de9b47c44366be3ee47f8e && nonuser_reverter
	    _committorevert=914b5519b1cd96f9ae19f1eec226e94af96354b9 && nonuser_reverter
	    _committorevert=99d047724e768822d6508573cd82a5c75b30bdcb && nonuser_reverter
	    _committorevert=413aad39135b0b0f8255500b85fcc05337a5f138 && nonuser_reverter
	    _committorevert=9ae8da6bb4a8f66d55975fa0f14e5e413756d324 && nonuser_reverter
	    _committorevert=de94cfa775f9f41d1d65cbd8e7bf861cd7f9a871 && nonuser_reverter
	    _committorevert=6dbb153ede48e77a87dddf37e5276276a701c5c3 && nonuser_reverter
	    _committorevert=81f8b6e8c215dc04a19438e4369fcba8f7f4f333 && nonuser_reverter
	    echo -e "( FS hack unbreak reverts applied )\n" >> "$_where"/last_build_config.log
	  elif git merge-base --is-ancestor 2538b0100fbbe1223e7c18a52bade5cfe5f8d3e3 HEAD && ! git merge-base --is-ancestor 0f972e2247932f255f131792724e4796b4b2b87a HEAD; then
	    _committorevert=16984895f0191dad12d55dee422214645b51aece && nonuser_reverter
	    _committorevert=0120a1aa40936fc6d57d83eb12709b951c7b88d6 && nonuser_reverter
	    _committorevert=4a330b29212402b9700828be82939112bd11a786 && nonuser_reverter
	    _committorevert=bbae35f0fb04ea7efb8e1d6e5535e42715ae7766 && nonuser_reverter
	    _committorevert=ec245c7e300f7cb779cf404079872f68c812585e && nonuser_reverter
	    _committorevert=586f68f414924b1e41fec10a72b1aacced068885 && nonuser_reverter
	    _committorevert=d9625e5a01a52496d1fb7f1a9a691fd3ec8332db && nonuser_reverter
	    _committorevert=715a04daabdab616b530ef5a937827df7c2523c3 && nonuser_reverter
	    _committorevert=f04360cfbec574dc37675df141ef8fc14e1302ba && nonuser_reverter
	    _committorevert=1aa7c9af90c340f45e03c6b94525704ad19eb657 && nonuser_reverter
	    _committorevert=fd29fe4ea73d87e39bd3d0ddd791c14f536508b7 && nonuser_reverter
	    _committorevert=2b484b1ac7a5510be54cb5341143d89dc1924b37 && nonuser_reverter
	    _committorevert=440fab3870b3c9ea778031ec51db69f8c3a687f5 && nonuser_reverter
	    _committorevert=b45c04f4c352ef81df5312684008839f4eeee03d && nonuser_reverter
	    _committorevert=9c99d9bceba34559a32f1e5906a6fcbcf91b0004 && nonuser_reverter
	    _committorevert=2116b49717f26802b51e2904de8d74651da33545 && nonuser_reverter
	    _committorevert=5491e939bc22f0ab479aec6b8a525be9c5ff5e35 && nonuser_reverter
	    _committorevert=d13b61b7385a6a380fb91720c511b194926fa0ca && nonuser_reverter
	    _committorevert=4a2481631331e2743476ea4e1b0005f8f5024242 && nonuser_reverter
	    _committorevert=0d42388095e4fd5c7702a61824b01ce0f9fc4d74 && nonuser_reverter
	    _committorevert=7dd52f6d24f372f08ab71f0acbb0a2b028d390ba && nonuser_reverter
	    _committorevert=9905a5a81d6baf59e992c5b2a8ea92ee4054e5d6 && nonuser_reverter
	    _committorevert=45d991d54138523e5278db5618eb458100982294 && nonuser_reverter
	    _committorevert=f5e6c086f91749e9e302c1abf858807535bc9775 && nonuser_reverter
	    _committorevert=a8b4cf7f2d3d1fbd79308a106a84e753cdac69e8 && nonuser_reverter
	    _committorevert=2a6de8d7f7d6f5ac018d8e330cfa580fc0c3b9e5 && nonuser_reverter
	    _committorevert=6f305dd881e16f77f9eb183684d04b0b8746b769 && nonuser_reverter
	    _committorevert=679ff720902b8e5d5d750b980084bdcdc9a051ed && nonuser_reverter
	    _committorevert=0b0ac41981006514616abdd4c4b6922cf66be7b6 && nonuser_reverter
	    _committorevert=dd13b274104b561f05873e8acdc4bfd34bbe796e && nonuser_reverter
	    _committorevert=3a3c7cbd209e23cc6ee88299b3ba877ab20a767f && nonuser_reverter
	    _committorevert=6f9d20806e821ab07c8adf81ae6630fae94b00ef && nonuser_reverter
	    _committorevert=145cfce1135a7e59cc4c89cd05b572403f188161 && nonuser_reverter
	    _committorevert=e3eb89d5ebb759e975698b97ed8b547a9de3853f && nonuser_reverter
	    _committorevert=707fcb99a60015fcbb20c83e9031bc5be7a58618 && nonuser_reverter
	    _committorevert=8cd6245b7633abccd68f73928544ae4de6f76d52 && nonuser_reverter
	    _committorevert=26b26a2e0efcb776e7b0115f15580d2507b10400 && nonuser_reverter
	    _committorevert=fd6f50c0d3e96947846ca82ed0c9bd79fd8e5b80 && nonuser_reverter
	    _committorevert=2538b0100fbbe1223e7c18a52bade5cfe5f8d3e3 && nonuser_reverter
	    echo -e "( FS hack unbreak reverts applied )\n" >> "$_where"/last_build_config.log
	  fi
	fi

	if [ "$_proton_rawinput" = "true" ] && [ "$_proton_fs_hack" = "true" ] && [ "$_use_staging" = "true" ] && ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 26c1131201f8fd9918a01231a7eb6f1989400858 HEAD ) && ( cd "${srcdir}"/"${_stgsrcdir}" && ! git merge-base --is-ancestor 82cff8bbdbc133cc14cdb9befc36c61c3e49c242 HEAD ); then
	  _committorevert=306c40e67319cae8e4c448ec8fc8d3996f87943f && nonuser_reverter
	  _committorevert=26c1131201f8fd9918a01231a7eb6f1989400858 && nonuser_reverter
	  echo -e "( Proton rawinput unbreak reverts applied )\n" >> "$_where"/last_build_config.log
	fi

	# Kernelbase reverts patchset - cleanly reverting part
	if [ "$_kernelbase_reverts" = "true" ] || [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_unfrog" != "true" ] && ! git merge-base --is-ancestor b7db0b52cee65a008f503ce727befcad3ba8d28a HEAD; then
	  _committorevert=b0199ea2fe8f9b77aee7ab4f68c9ae1755442586 && nonuser_reverter
	  _committorevert=608d086f1b1bb7168e9322c65224c23f34e75f29 && nonuser_reverter
	  _committorevert=b7db0b52cee65a008f503ce727befcad3ba8d28a && nonuser_reverter
	  _committorevert=3ede217e5cd80b18f709339aea281356579756cb && nonuser_reverter
	  _committorevert=87307de2173ee813daca9bd93ec750f17d3eda94 && nonuser_reverter
	  if [ "$_use_staging" != "true" ]; then
	    _committorevert=3dadd980bfbb2fb05a1a695decd06a429ddda97c && nonuser_reverter
	  fi
	  _committorevert=e5354008f46bc0e345c06ac06a7a7780faa9398b && nonuser_reverter
	  _committorevert=461b5e56f95eb095d97e4af1cb1c5fd64bb2862a && nonuser_reverter
	  echo -e "( Kernelbase reverts clean reverts applied )\n" >> "$_where"/last_build_config.log
	fi

	_commitmsg="01-reverts" _committer

	# Don't include *.orig and *~ files in the generated staging patchsets
	if [ "$_generate_patchsets" != "false" ] && [ "$_use_staging" = "true" ]; then
	  echo -e "*.orig\n*~" >> "${srcdir}"/"${_stgsrcdir}"/.gitignore
	  _commitmsg="gitignore" _committer
	fi

	# Hotfixer-staging
	if [ "$_NUKR" != "debug" ] && [ "$_unfrog" != "true" ] || [[ "$_DEBUGANSW2" =~ [yY] ]]; then
	  if [ "$_use_staging" = "true" ]; then
	    if [ "$_LOCAL_PRESET" != "staging" ] && [ "$_LOCAL_PRESET" != "mainline" ]; then
	      cd "${srcdir}"/"${_stgsrcdir}" && _userpatch_target="wine-staging" _userpatch_ext="mystaging" hotfixer && _commitmsg="01-staging-hotfixes" _committer && cd "${srcdir}"/"${_winesrcdir}"
	    fi
	  fi
	fi

	# Hotfixer early mainline
	if [ "$_NUKR" != "debug" ] && [ "$_unfrog" != "true" ] || [[ "$_DEBUGANSW1" =~ [yY] ]]; then
	  if [ "$_LOCAL_PRESET" != "staging" ] && [ "$_LOCAL_PRESET" != "mainline" ]; then
	    _userpatch_target="wine-mainline" _userpatch_ext="myearly" hotfixer
	  fi
	fi

	# wine-staging user patches
	if [ "$_user_patches" = "true" ]; then
	  _userpatch_target="wine-staging"
	  _userpatch_ext="mystaging"
	  cd "${srcdir}"/"${_stgsrcdir}"
	  user_patcher
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	# Update winevulkan
	if [ "$_update_winevulkan" = "true" ] && ! git merge-base --is-ancestor 3e4189e3ada939ff3873c6d76b17fb4b858330a8 HEAD && git merge-base --is-ancestor eb39d3dbcac7a8d9c17211ab358cda4b7e07708a HEAD; then
	  _patchname='winevulkan-1.1.103.patch' && _patchmsg="Applied winevulkan 1.1.103 patch" && nonuser_patcher
	fi
	if ( [ "$_update_winevulkan" = "true" ] || [ "$_proton_fs_hack" = "true" ] ); then
	  if [ -d "${srcdir}"/"${_stgsrcdir}"/patches/winevulkan-vkGetPhysicalDeviceSurfaceCapabilitiesKHR ]; then # ghetto check for winevulkan-vkGetPhysicalDeviceSurfaceCapabilitiesKHR staging patchset presence
	    _staging_args+=(-W winevulkan-vkGetPhysicalDeviceSurfaceCapabilitiesKHR)
	  fi
	fi

	# use CLOCK_MONOTONIC instead of CLOCK_MONOTONIC_RAW in ntdll/server - lowers overhead
	if [ "$_use_staging" != "true" ]; then
	  if [ "$_clock_monotonic" = "true" ] && [ "$_use_fastsync" != "true" ]; then
	    if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	      _patchname='use_clock_monotonic.patch' && _patchmsg="Applied clock_monotonic patch" && nonuser_patcher
	    else
	      _patchname='use_clock_monotonic-de679af.patch' && _patchmsg="Applied clock_monotonic patch" && nonuser_patcher
	    fi
	    if git merge-base --is-ancestor 13e11d3fcbcf8790e031c4bc52f5f550b1377b3b HEAD && ! git merge-base --is-ancestor cd215bb49bc240cdce5415c80264f8daa557636a HEAD; then
	      _patchname='use_clock_monotonic-2.patch' && _patchmsg="Applied clock_monotonic addon patch for 13e11d3" && nonuser_patcher
	    fi
	  fi
	fi

	# Fixes (partially) systray on plasma 5 - https://bugs.winehq.org/show_bug.cgi?id=38409
	if [ "$_plasma_systray_fix" = "true" ]; then
	  if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	    _patchname='plasma_systray_fix.patch' && _patchmsg="Applied plasma 5 systray fix" && nonuser_patcher
	  elif git merge-base --is-ancestor b87256cd1db21a59484248a193b6ad12ca2853ca HEAD; then
	    _patchname='plasma_systray_fix-0c249e6.patch' && _patchmsg="Applied plasma 5 systray fix" && nonuser_patcher
	  elif git merge-base --is-ancestor 473914f6a5943c4abfc8d0e394c71f395063d89f HEAD; then
	    _patchname='plasma_systray_fix-b87256c.patch' && _patchmsg="Applied plasma 5 systray fix (<b87256c)" && nonuser_patcher
	  else
	    _patchname='plasma_systray_fix-473914f.patch' && _patchmsg="Applied plasma 5 systray fix (<473914f)" && nonuser_patcher
	  fi
	fi

	# Bypass compositor in fullscreen mode - Reduces stuttering and improves performance
	if [ "$_FS_bypass_compositor" = "true" ] && [ "$_FS_bypass_compositor_legacy" != "false" ]; then
	  _patchname='FS_bypass_compositor.patch' && _patchmsg="Applied Fullscreen compositor bypass patch" && nonuser_patcher
	fi

	# Use faudio for xaudio2
	if git merge-base --is-ancestor d5a372abbba2e174de78855bdd4a004b56cdc006 HEAD; then # include: Move inline assembly definitions to a new wine/asm.h header.
	  _use_faudio="true"
	fi
	if [ "$_use_faudio" = "true" ] && [ "$_use_staging" = "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  if ! git merge-base --is-ancestor b95b9109b824d21d98329c76387c3983d6e27cc2 HEAD; then
	    cd "${srcdir}"/"${_winesrcdir}"
	    if git merge-base --is-ancestor 9422b844b59282db04af533451f50661de56b9ca HEAD; then
	      _staging_args+=(-W xaudio2-revert -W xaudio2_7-CreateFX-FXEcho -W xaudio2_7-WMA_support -W xaudio2_CommitChanges) # Disable xaudio2 staging patchsets for faudio
	    elif git merge-base --is-ancestor 47fbcece36cad190c4d18f7636df67d1382b7545 HEAD && ! git merge-base --is-ancestor 3e390b1aafff47df63376a8ca4293c515d74f4ba HEAD; then
	      _patchname='faudio-exp.patch' && _patchmsg="Applied faudio for xaudio2 patch" && nonuser_patcher
	      _staging_args+=(-W xaudio2_7-CreateFX-FXEcho -W xaudio2_7-WMA_support -W xaudio2_CommitChanges) # Disable xaudio2 staging patchsets for faudio
	    fi
	  fi
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	# Disable winex11-WM_WINDOWPOSCHANGING and winex11-_NET_ACTIVE_WINDOW patchsets on proton-tkg staging
	#if ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	  if [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_use_staging" = "true" ] || [ "$_proton_fs_hack" = "true" ]; then
	    _staging_args+=(-W winex11-WM_WINDOWPOSCHANGING -W winex11-_NET_ACTIVE_WINDOW)
	    if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 76f8eb15f17ff9ae52f6c2b61824978762d421ef HEAD ) && [ -e "${srcdir}/${_stgsrcdir}/patches/imm32-com-initialization/definition" ] && ! grep -Fxq 'Disabled: true' "${srcdir}/${_stgsrcdir}/patches/imm32-com-initialization/definition"; then
	      _staging_args+=(-W imm32-com-initialization)
	    fi
	  fi
	#fi

	# Disable winex11.drv-mouse-coorrds and winex11-MWM_Decorations patchsets on staging for proton FS hack
	if [ "$_proton_fs_hack" = "true" ] && [ "$_use_staging" = "true" ] && ! git merge-base --is-ancestor 0f972e2247932f255f131792724e4796b4b2b87a HEAD; then
	  if [ "$_broken_staging_44d1a45_localreverts" != "true" ] && ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 44d1a45e983ed8c04390068ded61294e2004d2f6 HEAD && ! git merge-base --is-ancestor 82cff8bbdbc133cc14cdb9befc36c61c3e49c242 HEAD ); then
	    if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 437038604a09c7952a52b28c373cfbe706d8e78b HEAD ); then
	      sed -i 's/-@@ -3383,3 +3393,14 @@ DECL_HANDLER(get_rawinput_devices)/-@@ -3432,3 +3442,14 @@ DECL_HANDLER(get_rawinput_devices)/g' "$_where"/staging-44d1a45-localreverts.patch
	    fi
	    cd "${srcdir}"/"${_stgsrcdir}" && _patchname='staging-44d1a45-localreverts.patch' _patchmsg="Applied local reverts for staging 44d1a45 fshack" nonuser_patcher && cd "${srcdir}"/"${_winesrcdir}"
	  fi
	  if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 7cc69d770780b8fb60fb249e007f1a777a03e51a HEAD ); then
	    _staging_args+=(-W winex11.drv-mouse-coorrds -W winex11-MWM_Decorations)
	    if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 938dddf7df920396ac3b30a44768c1582d0c144f HEAD && ! git merge-base --is-ancestor fd3bb06a4c1102cf424bc78ead25ee440db1b0fa HEAD ); then
	      _staging_args+=(-W user32-rawinput)
	    fi
	    if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 8218a789558bf074bd26a9adf3bbf05bdb9cb88e HEAD && ! git merge-base --is-ancestor 82cff8bbdbc133cc14cdb9befc36c61c3e49c242 HEAD ); then
	      _staging_args+=(-W user32-rawinput-mouse -W user32-rawinput-nolegacy -W user32-rawinput-mouse-experimental -W user32-rawinput-hid -W winex11-key_translation)
	      if ( cd "${srcdir}"/"${_stgsrcdir}" && ! git merge-base --is-ancestor d8496cacd170347bbde755ead066be8394fbb82b HEAD ); then
	        _staging_args+=(-W user32-rawinput-keyboard)
	      fi
	    elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor f904ca32a3f678bf829a325dc66699a21e510857 HEAD ); then
	      _staging_args+=(-W user32-rawinput-mouse -W user32-rawinput-mouse-experimental -W user32-rawinput-hid)
	    fi
	  fi
	fi

	# Specifically for proton-tkg, our meta patchset breaks with stock staging rawinput patchset, so disable for now, and apply a corresponding fixed winex11-key_translation patchset at a later stage
	if [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_use_staging" = "true" ] && [ "$_proton_fs_hack" != "true" ] && ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 8218a789558bf074bd26a9adf3bbf05bdb9cb88e HEAD ) && ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	  if ( cd "${srcdir}"/"${_stgsrcdir}" && ! git merge-base --is-ancestor 82cff8bbdbc133cc14cdb9befc36c61c3e49c242 HEAD ); then
	    _staging_args+=(-W user32-rawinput-mouse -W user32-rawinput-nolegacy -W user32-rawinput-mouse-experimental -W user32-rawinput-hid -W winex11-key_translation)
	  elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor f904ca32a3f678bf829a325dc66699a21e510857 HEAD ); then
	    _staging_args+=(-W user32-rawinput-mouse -W user32-rawinput-mouse-experimental -W user32-rawinput-hid)
	  fi
	  if ( cd "${srcdir}"/"${_stgsrcdir}" && ! git merge-base --is-ancestor d8496cacd170347bbde755ead066be8394fbb82b HEAD ); then
	    _staging_args+=(-W user32-rawinput-keyboard)
	  fi
	  if [ "$_proton_fs_hack" = "false" ] && [ "$_broken_staging_44d1a45_localreverts" != "true" ] && ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 44d1a45e983ed8c04390068ded61294e2004d2f6 HEAD && ! git merge-base --is-ancestor 82cff8bbdbc133cc14cdb9befc36c61c3e49c242 HEAD ); then
	    if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 437038604a09c7952a52b28c373cfbe706d8e78b HEAD ); then
	      sed -i 's/-@@ -3383,3 +3393,14 @@ DECL_HANDLER(get_rawinput_devices)/-@@ -3432,3 +3442,14 @@ DECL_HANDLER(get_rawinput_devices)/g' "$_where"/staging-44d1a45-localreverts.patch
	    fi
	    cd "${srcdir}"/"${_stgsrcdir}" && _patchname='staging-44d1a45-localreverts.patch' _patchmsg="Applied local reverts for staging 44d1a45 proton-nofshack" nonuser_patcher && cd "${srcdir}"/"${_winesrcdir}"
	  fi
	fi

	# Disable some staging patchsets to prevent bad interactions with proton gamepad additions
	if ( ! git merge-base --is-ancestor 6373792eec0f122295723cae77b0115e6c96c3e4 HEAD && [ "$_gamepad_additions" = "true" ] && [ "$_EXTERNAL_INSTALL" = "proton" ] ) || ( git merge-base --is-ancestor 6373792eec0f122295723cae77b0115e6c96c3e4 HEAD && [ "$_sdl_joy_support" = "true" ] && ( git merge-base --is-ancestor a17367291104e46c573b7213ee94a0f537563ace HEAD || [ "$_EXTERNAL_INSTALL" = "proton" ] ) ) && [ "$_use_staging" = "true" ] && ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor 2bd3c9703d3385820c1829a78ef71e7701d3a77a HEAD ); then
	  _staging_args+=(-W dinput-SetActionMap-genre -W dinput-axis-recalc -W dinput-joy-mappings -W dinput-reconnect-joystick -W dinput-remap-joystick)
	fi

	# Fixes for staging based Proton + steamhelper
	if [ "$_steamclient_noswap" = "true" ]; then
	  _proton_use_steamhelper="false"
	fi
	if ( [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_use_staging" = "true" ] && [ "$_proton_use_steamhelper" = "true" ] ); then
	  if ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	    if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 7fc716aa5f8595e5bca9206f86859f1ac70894ad HEAD ); then
	      _staging_args+=(-W ws2_32-TransmitFile) # Might not be actually required with server-Desktop_Refcount gone - needs testing
	    elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 4e7071e4f14f6ce85b0eb4b88accfb0267d6545b HEAD ); then
	      _staging_args+=(-W server-Desktop_Refcount -W ws2_32-TransmitFile)
	    fi
	  fi
	fi

	# Disable broken rawinput patchset that was enabled between e09468e and 5b066d6
	if [ "$_use_staging" = "true" ] && ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor e09468ec178930ac7b1ee33482cd03f0cc136685 HEAD && ! git merge-base --is-ancestor 5b066d6aed7fd90c0be0a2a156b0e5c6cbb44bba HEAD ); then
	  _staging_args+=(-W user32-rawinput)
	fi

	# Disable Staging's `xactengine-initial` patchset to fix BGM on KOF98 & 2002
	if [ "$_kof98_2002_BGM_fix" = "true" ] && [ "$_use_staging" = "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  if git merge-base --is-ancestor 2fc5c88068e3dea2612c182ff300511aa2954242 HEAD && ! git merge-base --is-ancestor e4a11b16639179734e1d9f12ab4605dcbfa21a27 HEAD; then
	    _staging_args+=(-W xactengine-initial)
	  fi
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	# Patch to allow Path of Exile to run with DirectX11
	# https://bugs.winehq.org/show_bug.cgi?id=42695
	if [ "$_poe_fix" = "true" ]; then
	  _patchname='poe-fix.patch' && _patchmsg="Applied Path of Exile DX11 fix" && nonuser_patcher
	fi

	# Fix for Warframe Launcher failing to update itself - https://bugs.winehq.org/show_bug.cgi?id=33845 https://bugs.winehq.org/show_bug.cgi?id=45701 - Merged in staging 8b930ae and mainline 04ccd99
	if [ "$_warframelauncher_fix" = "true" ]; then
	  if [ "$_use_staging" = "true" ] && ! git merge-base --is-ancestor 33c35baa6761b00c8cef236c06cb1655f3f228d9 HEAD || [ "$_use_staging" != "true" ] && ! git merge-base --is-ancestor 04ccd995b1aec5eac5874454a320b37676b69c42 HEAD; then
	    _patchname='warframe-launcher.patch' && _patchmsg="Applied Warframe Launcher fix" && nonuser_patcher
	  fi
	fi

	# Workaround for F4SE/SkyrimSE Script Extender
	# https://github.com/hdmap/wine-hackery/tree/master/f4se
	if [ "$_f4skyrimse_fix" = "true" ]; then
	  if ! git merge-base --is-ancestor 12be24af8cab0e5f78795b164ec8847bafc30852 HEAD; then
	    _patchname='f4skyrimse-fix-1.patch' && _patchmsg="Applied F4/SkyrimSE Script Extender fix (1)" && nonuser_patcher
	  fi
	  if ! git merge-base --is-ancestor 1aa963efd7c7c7f91423f5edb9811f6ff95c06c0 HEAD; then
	    if git merge-base --is-ancestor 4c750a35c3c087d1fa9b0882fb0bdd6804296473 HEAD; then
	      _patchname='f4skyrimse-fix-2.patch' && _patchmsg="Applied F4/SkyrimSE Script Extender fix (2)" && nonuser_patcher
	    elif git merge-base --is-ancestor be48a56e700d47f2221d983a37ef70228508c11b HEAD; then
	      _patchname='f4skyrimse-fix-2-4c750a3.patch' && _patchmsg="Applied F4/SkyrimSE Script Extender fix (2)" && nonuser_patcher
	    elif git merge-base --is-ancestor 00451d5edf9a13fd8f414a0d06869e38cf66b754 HEAD; then
	      _patchname='f4skyrimse-fix-2-be48a56.patch' && _patchmsg="Applied F4/SkyrimSE Script Extender fix (2)" && nonuser_patcher
	    else
	      _patchname='f4skyrimse-fix-2-00451d5.patch' && _patchmsg="Applied F4/SkyrimSE Script Extender fix (2)" && nonuser_patcher
	    fi
	  fi
	fi

	# Magic The Gathering: Arena crash fix - (<aa0c4bb5e72caf290b6588bc1f9931cc89a9feb6)
	if [ "$_mtga_fix" = "true" ] && ! git merge-base --is-ancestor aa0c4bb5e72caf290b6588bc1f9931cc89a9feb6 HEAD; then
	  if ! git merge-base --is-ancestor ce7e10868a1279573acc5be5a9659d254e936b27 HEAD; then
	    _patchname='mtga-legacy-addition.patch' && _patchmsg="Applied MTGA msi installers hack" && nonuser_patcher
	  fi
	  _patchname='mtga-legacy.patch' && _patchmsg="Applied MTGA crashfix" && nonuser_patcher
	fi

	# The Sims 2 fix - disable wined3d-WINED3D_RS_COLORWRITEENABLE and wined3d-Indexed_Vertex_Blending staging patchsets for 4.2+devel and lower - The actual patch is applied after staging
	if [ "$_sims2_fix" = "true" ] && ! git merge-base --is-ancestor d88f12950761e9ff8d125a579de6e743979f4945 HEAD; then
	  _staging_args+=(-W wined3d-WINED3D_RS_COLORWRITEENABLE -W wined3d-Indexed_Vertex_Blending)
	fi

	# The Sims 3 fix - reverts 6823abd521c0c12d20d9171fb5ae8b300009d082 to fix Sims 3 on older than 415.xx nvidia drivers - https://bugs.winehq.org/show_bug.cgi?id=45361
	if [ "$_sims3_fix" = "true" ]; then
	  if git merge-base --is-ancestor 83c9e5243a663370296148471628a350ba9422c6 HEAD; then
	    _patchname='sims_3-oldnvidia.patch' && _patchmsg="Applied The Sims 3 Debian&co nvidia fix" && nonuser_patcher
	  elif git merge-base --is-ancestor 6823abd521c0c12d20d9171fb5ae8b300009d082 HEAD; then
	    _patchname='sims_3-oldnvidia-83c9e52.patch' && _patchmsg="Applied The Sims 3 Debian&co nvidia fix" && nonuser_patcher
	  fi
	fi

	# Python fix for <=3.18 (backported from zzhiyi's patches) - fix for python and needed for "The Sims 4" to work - replaces staging partial implementation - https://bugs.winehq.org/show_bug.cgi?id=44999 - The actual patch is applied after staging
	if [ "$_318python_fix" = "true" ] && ! git merge-base --is-ancestor 3ebd2f0be30611e6cf00468c2980c5092f91b5b5 HEAD; then
	  _staging_args+=(-W kernelbase-PathCchCombineEx)
	fi

	# Mechwarrior Online fix - https://mwomercs.com/forums/topic/268847-running-the-game-on-ubuntu-steam-play/page__st__20__p__6195387#entry6195387
	if [ "$_mwo_fix" = "true" ]; then
	  _patchname='mwo.patch' && _patchmsg="Applied Mechwarrior Online fix" && nonuser_patcher
	fi

	# Resident Evil 4 hack - https://bugs.winehq.org/show_bug.cgi?id=46336
	if [ "$_re4_fix" = "true" ] && [ "$_wined3d_additions" = "false" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  if [ "$_use_staging" = "true" ] && git merge-base --is-ancestor 2e4d0f472736529f59bd92dd3863731cd6bab875 HEAD; then
	    cd "${srcdir}"/"${_winesrcdir}" && echo "RE4 fix disabled for the selected Wine-staging version" >> "$_where"/last_build_config.log
	  else
	    cd "${srcdir}"/"${_winesrcdir}" && _patchname='resident_evil_4_hack.patch' && _patchmsg="Applied Resident Evil 4 hack" && nonuser_patcher
	  fi
	fi

	# Child window support for vk - Fixes World of Final Fantasy and others - https://bugs.winehq.org/show_bug.cgi?id=45277
	if [ "$_childwindow_fix" = "true" ]; then
	  if ( [ "$_proton_fs_hack" != "true" ] && git merge-base --is-ancestor 0f972e2247932f255f131792724e4796b4b2b87a HEAD ) || ( ! git merge-base --is-ancestor 0f972e2247932f255f131792724e4796b4b2b87a HEAD ); then
	    if git merge-base --is-ancestor 011fabb2c43d13402ea18b6ea7be3669b5e6c7a8 HEAD; then
	      _staging_args+=(-W Pipelight -W winex11-Vulkan_support)
	      if git merge-base --is-ancestor bca1b7f2faeb0798f4af420c15ff5a1b1f7b40af HEAD; then
	        _patchname='childwindow.patch' && _patchmsg="Applied child window for vk patch" && nonuser_patcher
	      else
	        _patchname='childwindow-bca1b7f.patch' && _patchmsg="Applied child window for vk patch" && nonuser_patcher
	      fi
	    else
	      _patchname='childwindow-011fabb.patch' && _patchmsg="Applied child window for vk patch" && nonuser_patcher
	    fi
	  fi
	fi

	# Workaround for https://bugs.winehq.org/show_bug.cgi?id=47633
	if [ "$_nativedotnet_fix" = "true" ] && git merge-base --is-ancestor 0116660dd80b38da8201e2156adade67fc2ae823 HEAD && ! git merge-base --is-ancestor 505be3a0a2afeae3cebeaad48fc5f32e0b0336b7 HEAD; then
	  _patchname='0001-kernelbase-Remove-DECLSPEC_HOTPATCH-from-SetThreadSt.patch' && _patchmsg="Applied native dotnet workaround (https://bugs.winehq.org/show_bug.cgi?id=47633)" && nonuser_patcher
	fi

	# USVFS (Mod Organizer 2's virtual filesystem) patch
	if [ "$_usvfs_fix" = "true" ] && ! git merge-base --is-ancestor ee266aba74809b0fb4833f2d2762d3c687be4dd0 HEAD; then
	  _patchname='usvfs.patch' && _patchmsg="Applied USVFS (Mod Organizer 2's virtual filesystem) patch" && nonuser_patcher
	fi

	# Reverts c6b6935 due to https://bugs.winehq.org/show_bug.cgi?id=47752
	if [ "$_c6b6935_revert" = "true" ] && ! git merge-base --is-ancestor cb703739e5c138e3beffab321b84edb129156000 HEAD; then
	  _patchname='revert-c6b6935.patch' && _patchmsg="Reverted c6b6935 to fix regression affecting performance negatively" && nonuser_patcher
	fi

	# steam crossover hack for store/web functionality
	# https://bugs.winehq.org/show_bug.cgi?id=39403
	if [ "$_steam_fix" = "true" ]; then
	  if git merge-base --is-ancestor 712ae337fe02c2e222e7c3067e5f624160bb84a1 HEAD; then
	    _patchname='steam.patch' && _patchmsg="Applied steam crossover hack" && nonuser_patcher
	  else
	    _patchname='steam-712ae33.patch' && _patchmsg="Applied steam crossover hack" && nonuser_patcher
	  fi
	fi

	# Disable server-send_hardware_message staging patchset if found - Fixes FFXIV/Warframe/Crysis 3 (...) mouse jittering issues on 3.19 staging and lower.
	if [ "$_server_send_hwmsg_disable" = "true" ] && [ "$_use_staging" = "true" ]; then
	  if [ -d "${srcdir}"/"${_stgsrcdir}"/patches/server-send_hardware_message ]; then # ghetto check for server-send_hardware_message staging patchset presence
	    _staging_args+=(-W server-send_hardware_message)
	    echo "server-send_hardware_message staging patchset disabled (mouse jittering fix)" >> "$_where"/last_build_config.log
	  fi
	fi

	# Disable winepulse pulseaudio patchset
	if [ "$_use_staging" = "true" ] && ! grep -Fxq 'Disabled: True' "${srcdir}/${_stgsrcdir}/patches/winepulse-PulseAudio_Support/definition"; then
	  if [ "$_staging_pulse_disable" = "true" ] && [[ ! ${_staging_args[*]} =~ "winepulse-PulseAudio_Support" ]]; then
	    _staging_args+=(-W winepulse-PulseAudio_Support)
	    echo "Disabled the staging winepulse patchset" >> "$_where"/last_build_config.log
	  fi
	fi

	# CSMT toggle patch - Corrects the CSMT toggle to be more logical
	if [ "$_CSMT_toggle" = "true" ] && [ "$_use_staging" = "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  if git merge-base --is-ancestor ef11bb63ce54490bc5a1e14ab650207b515340da HEAD; then
	    _patchname='CSMT-toggle.patch' && _patchmsg="Applied CSMT toggle logic patch" && nonuser_patcher
	  elif git merge-base --is-ancestor 5e685d6df972b658fba296dafb5db189af73c7d5 HEAD; then
	    _patchname='CSMT-toggle-ef11bb6.patch' && _patchmsg="Applied CSMT toggle logic patch" && nonuser_patcher
	  else
	    _patchname='CSMT-toggle-5e685d6.patch' && _patchmsg="Applied CSMT toggle logic patch" && nonuser_patcher
	  fi
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	# Proton Bcrypt patches
	if [ "$_use_staging" = "true" ]; then
	  if [ "$_proton_bcrypt" = "true" ] && ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 37e000145f07c4ec6f48fdac5969bbbb05435d52 HEAD ) && ! grep -Fxq 'Disabled: true' "${srcdir}/${_stgsrcdir}/patches/bcrypt-ECDHSecretAgreement/definition"; then
	    if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 74c0da2d71e95f3e6bd6c8b440652933771b27d7 HEAD );then
	      _staging_args+=(-W bcrypt-ECDHSecretAgreement)
	    fi
	  fi
	fi

	_commitmsg="02-pre-staging" _committer

	if [ "$_use_staging" = "true" ] && [ "$_NUKR" != "debug" ] || [[ "$_DEBUGANSW2" =~ [yY] ]]; then
	  # We're converting our array to string to allow manipulation
	  if ( cd "${srcdir}"/"${_stgsrcdir}" && ! git merge-base --is-ancestor b8ca0eae9f47491ba257c422a2bc03fc37d13c22 HEAD ); then
	    _staging_args=$( printf "%s" "${_staging_args[*]}" | sed 's/-W ntdll-NtAlertThreadByThreadId // ; s/ -W ntdll-NtAlertThreadByThreadId// ; s/-W ntdll-NtAlertThreadByThreadId//' )
	  else
	    _staging_args=$( printf "%s" "${_staging_args[*]}" )
	  fi
	  msg2 "Applying wine-staging patches... \n     Staging overrides used, if any: ${_staging_args}" && echo -e "\nStaging overrides, if any: ${_staging_args}\n" >> "$_where"/last_build_config.log && echo -e "\nApplying wine-staging patches..." >> "$_where"/prepare.log
	  "${srcdir}"/"${_stgsrcdir}"/patches/patchinstall.sh DESTDIR="${srcdir}/${_winesrcdir}" --all $_staging_args >> "$_where"/prepare.log 2>&1 || (error "Patch application has failed. The error was logged to $_where/prepare.log for your convenience."; msg2 "To use the last known good mainline version, please set _plain_version=\"$_last_known_good_mainline\" in your .cfg"; msg2 "To use the last known good staging version, please set _staging_version=\"$_last_known_good_staging\" in your .cfg (requires _use_staging=\"true\")" && exit 1)

	  # Remove staging version tag
	  sed -i "s/  (Staging)//g" "${srcdir}"/"${_winesrcdir}"/libs/wine/Makefile.in
	  _commitmsg="03-staging" _committer
	fi

	# use CLOCK_MONOTONIC instead of CLOCK_MONOTONIC_RAW in ntdll/server - lowers overhead
	if [ "$_use_staging" = "true" ]; then
	  if [ "$_clock_monotonic" = "true" ] && [ "$_use_fastsync" != "true" ]; then
	    if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor a1a2d654886fe71af49f9f64210e21d743976ffe HEAD ); then
	      _patchname='use_clock_monotonic-staging.patch' && _patchmsg="Applied clock_monotonic patch" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	      _patchname='use_clock_monotonic.patch' && _patchmsg="Applied clock_monotonic patch" && nonuser_patcher
	    else
	      _patchname='use_clock_monotonic-de679af.patch' && _patchmsg="Applied clock_monotonic patch" && nonuser_patcher
	    fi
	    if git merge-base --is-ancestor 13e11d3fcbcf8790e031c4bc52f5f550b1377b3b HEAD && ! git merge-base --is-ancestor cd215bb49bc240cdce5415c80264f8daa557636a HEAD; then
	      _patchname='use_clock_monotonic-2.patch' && _patchmsg="Applied clock_monotonic addon patch for 13e11d3" && nonuser_patcher
	    fi
	  fi
	fi

	# winesync / fastsync
	if [ "$_use_fastsync" = "true" ]; then
	  if [ "$_use_staging" != "true" ]; then
	    _use_esync="false"
	    _use_fsync="false"
	    if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor fa5759b9efad3b00e8ce349889e411792748f87f HEAD ); then
	      _patchname='fastsync-mainline.patch' && _patchmsg="Using fastsync patchset" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 21f5597de417575d476a00b567d972a89903b4b6 HEAD ); then
	      msg2 "Skipping non-rebased fastsync patchset"
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0cdc52c65cadd0e17153856e6026e8cfc9bec985 HEAD ); then
	      _patchname='fastsync-mainline-21f5597.patch' && _patchmsg="Using fastsync patchset" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor f3d41cc7897635311cf868759f95b4bf5253703b HEAD ); then
	      _patchname='fastsync-mainline-0cdc52c.patch' && _patchmsg="Using fastsync patchset" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 3386560057c0d30461af0973fd9dac9871387143 HEAD ); then
	      _patchname='fastsync-mainline-f3d41cc.patch' && _patchmsg="Using fastsync patchset" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 5df0f5f6fb90e1326b71cd1094a7b710b94916d4 HEAD ); then
	      _patchname='fastsync-mainline-3386560.patch' && _patchmsg="Using fastsync patchset" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 340cc46287d7861ce6cae19401752e65f4089ae9 HEAD ); then
	      _patchname='fastsync-mainline-5df0f5f.patch' && _patchmsg="Using fastsync patchset" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 3c9b5379d1a57f69fa14f87f64f2079171becb6c HEAD ); then
	      _patchname='fastsync-mainline-340cc46.patch' && _patchmsg="Using fastsync patchset" && nonuser_patcher
	    fi
	  else
	    warning "! _use_fastsync is enabled, but _use_staging disables it. Please disable _use_staging in your .cfg to use fastsync !"
	    _use_fastsync="false"
	  fi
	fi

	# esync
	if [ "$_use_esync" = "true" ]; then
	  if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 6fdae1979bace3b2832fe099475e4368f543c13f HEAD ); then
	    _patchname='esync-unix-mainline.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor dd882794d2b226c59a306d1b39b9529ac431479c HEAD ); then
	    _patchname='esync-unix-mainline-6fdae19.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor a87bafc5b92c9f2deaa399e32a8ec42d28f7ea45 HEAD ); then
	    _patchname='esync-unix-mainline-dd88279.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 10ca57f4f56f86b433686afbdbe140ba54b239bb HEAD ); then
	    _patchname='esync-unix-mainline-a87bafc.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 3fb4d1f779770eab44d3f56fb9e95899b3791ca5 HEAD ); then
	    _patchname='esync-unix-mainline-10ca57f.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 2084fbd93dd607a6534eba7cab7dd60e0a12ca37 HEAD ); then
	    _patchname='esync-unix-mainline-3fb4d1f.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 6b277dc89d5532b83dc4116d7eba70e88d508fa0 HEAD ); then
	    _patchname='esync-unix-mainline-2084fbd.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 6a9e19344dae44e97361041996f237f4bfd905c6 HEAD ); then
	    _patchname='esync-unix-mainline-6b277dc.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 64cfcc1c62c2e1ca25ade05973675c64bbc3356e HEAD ); then
	    _patchname='esync-unix-mainline-6a9e193.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 731339cd60c255fd5890063b144ad7c00661f5a0 HEAD ); then
	    _patchname='esync-unix-mainline-64cfcc1.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 3c9b5379d1a57f69fa14f87f64f2079171becb6c HEAD ); then
	    _patchname='esync-unix-mainline-731339c.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 816b588e0438f94a3769612739abc9d8d9980537 HEAD ); then
	    _patchname='esync-unix-mainline-3c9b537.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor a0a62463e3d1d053459a194e2e1bcc91bfbec0f5 HEAD ); then
	    _patchname='esync-unix-mainline-816b588.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor d6ef9401b3ef05e87e0cadd31992a6809008331e HEAD ); then
	    _patchname='esync-unix-mainline-a0a6246.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor c6f2aacb5761801a17b930086111f4b2c4a30075 HEAD ); then
	    _patchname='esync-unix-mainline-d6ef940.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 44699c324f20690f9d6836919534ca1b5bcc3efe HEAD ); then
	    _patchname='esync-unix-mainline-c6f2aac.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 2b6426da6550c50787eeb2b39affcb766e07ec11 HEAD ); then
	    _patchname='esync-unix-mainline-44699c3.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor c1a042cefbc38eae6e0824a460a0657148e6745a HEAD ); then
	    _patchname='esync-unix-mainline-2b6426d.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 2a132a18390e848b90c0273e891cbeb6d140bc70 HEAD ); then
	    _patchname='esync-unix-mainline-c1a042c.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 2a132a18390e848b90c0273e891cbeb6d140bc70 HEAD ); then
	    _patchname='esync-unix-mainline-3100197.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor cf49617c1a378dd4a37ab7226187708c501b046f HEAD ); then
	    _patchname='esync-unix-mainline-2a132a1.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 459d37643ef72d284eec0dc50573eff59935ae69 HEAD ); then
	    _patchname='esync-unix-mainline-7bdc1d6.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	    _patchname='esync-unix-mainline-459d376.patch' && _patchmsg="Using Esync (unix, mainline) patchset" && nonuser_patcher
	  elif git merge-base --is-ancestor 2600ecd4edfdb71097105c74312f83845305a4f2 HEAD; then # Esync ce79346
	    if [ "$_use_staging" = "true" ]; then
	      # fixes for esync patches to apply to staging
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-staging-fixes-r3.patch' && _patchmsg="Using esync staging 3.20+ compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    cd "${srcdir}"/"${_esyncsrcdir}"
	    _patchname='esync-compat-fixes-r3.patch' && _patchmsg="Using esync 3.20+ compat fixes" && nonuser_patcher
	    cd "${srcdir}"/"${_winesrcdir}"

	    # if using a wine version that includes 7ba361b, apply 4.4+ additional fixes
	    if git merge-base --is-ancestor 7ba361b47bc95df624eac83c170d6c1a4041d8f8 HEAD; then # ntdll: Add support for returning previous state argument in event functions
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.1.patch' && _patchmsg="Using esync 4.4+ additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes b2a546c, apply 4.5+ additional fixes
	    if git merge-base --is-ancestor b2a546c92dabee8ab1c3d5b9fecc84d99caf0e76 HEAD; then # server: Introduce kernel_object struct for generic association between server and kernel objects.
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.2.patch' && _patchmsg="Using esync 4.5+ additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes b3c8d5d, apply 4.6+ additional fixes
	    if git merge-base --is-ancestor b3c8d5d36850e484b5cc84ab818a75db567a06a3 HEAD; then # ntdll: Use static debug info before initialization is done. 
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.3.patch' && _patchmsg="Using esync 4.6+(b3c8d5d) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes 4c0e817, apply 4.6+ additional fixes
	    if git merge-base --is-ancestor 4c0e81728f6db575d9cbd8feb8a5374f1adec9bb HEAD; then # ntdll: Use static debug info before initialization is done. 
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.4.patch' && _patchmsg="Using esync 4.6+(4c0e817) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes f534fbd, apply 4.6+ additional fixes
	    if git merge-base --is-ancestor f534fbd3e3c83df49c7c6b8e608a99f2af65adc0 HEAD; then # server: Allow creating process kernel objects.
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.5.patch' && _patchmsg="Using esync 4.6+(f534fbd) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes 29914d5, apply 4.8+ additional fixes
	    if git merge-base --is-ancestor 29914d583fe098521472332687b8da69fc692690 HEAD; then # server: Pass file object handle in IRP_CALL_CREATE request.
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.6.patch' && _patchmsg="Using esync 4.8+(29914d5) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes 608d086, apply 4.20+ additional fixes
	    if git merge-base --is-ancestor 608d086f1b1bb7168e9322c65224c23f34e75f29 HEAD; then
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.7.patch' && _patchmsg="Using esync 4.20+(608d086) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes 4538a13, apply 4.20+ additional fixes
	    if git merge-base --is-ancestor 4538a137e089240f1981f0d6f82fb8d63a65f4f6 HEAD; then
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.8.patch' && _patchmsg="Using esync 4.20+(4538a13) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes b934f66, apply 4.21+ additional fixes
	    if git merge-base --is-ancestor b934f6626ed7cb8a6cc18b261550d363a0068141 HEAD; then
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.9.patch' && _patchmsg="Using esync 4.21+(b934f66) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes fc17535, apply 4.21+ additional fixes
	    if git merge-base --is-ancestor fc17535eb98a4b200d6a418337a7e280568c7cfd HEAD; then
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.10.patch' && _patchmsg="Using esync 4.21+(fc17535) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes b664ae8, apply 5.5+ additional fixes
	    if git merge-base --is-ancestor b664ae8e60e08224cdc3025c28a37cb22356aaa4 HEAD; then
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.11.patch' && _patchmsg="Using esync 5.5+(b664ae8) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes 8701260, apply 5.6+ additional fixes
	    if git merge-base --is-ancestor 87012607688f730755ee91de14620e6e3b78395c HEAD; then
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.12.patch' && _patchmsg="Using esync 5.6+(8701260) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes 40e849f, apply 5.7+ additional fixes
	    if git merge-base --is-ancestor 40e849ffa46ae3cd060e2db83305dda1c4d2648e HEAD; then
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.13.patch' && _patchmsg="Using esync 5.7+(40e849f) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes e5030a4, apply 5.8+ additional fixes
	    if git merge-base --is-ancestor e5030a4ac0a303d6788ae79ffdcd88e66cf78bd2 HEAD; then
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.14.patch' && _patchmsg="Using esync 5.8+(e5030a4) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes 2633a5c, apply 5.8+ additional fixes
	    if git merge-base --is-ancestor 2633a5c1ae542f08f127ba737fa59fb03ed6180b HEAD; then
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.15.patch' && _patchmsg="Using esync 5.8+(2633a5c) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes a1c46c3, apply 5.9+ additional fixes
	    if git merge-base --is-ancestor a1c46c3806a054c16fab9fd9d8388e55eb473536 HEAD; then
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.16.patch' && _patchmsg="Using esync 5.9+(a1c46c3) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi
	  # if using a wine version that includes aec7bef, use 3.17+ fixes
	  elif git merge-base --is-ancestor aec7befb5115d866724149bbc5576c7259fef820 HEAD; then # server: Avoid potential size overflow for empty object attributes
	    if [ "$_use_staging" = "true" ]; then
	      # fixes for esync patches to apply to staging
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-staging-fixes-r2.patch' && _patchmsg="Using esync staging 3.17+ compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    # if using a wine version that includes c099655, use 3.19+ addon fixes
	    elif git merge-base --is-ancestor c0996553a1d9056e1b89871fc8c3fb0bfb5a4f0c HEAD; then #  server: Support FILE_SKIP_COMPLETION_PORT_ON_SUCCESS on server-side asyncs
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r2.1.patch' && _patchmsg="Using esync 3.19+ compat addon fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    cd "${srcdir}"/"${_esyncsrcdir}"
	    _patchname='esync-compat-fixes-r2.patch' && _patchmsg="Using esync 3.17+ compat fixes" && nonuser_patcher
	    cd "${srcdir}"/"${_winesrcdir}"
	  else
	    # 3.10 - 3.16
	    if [ "$_use_staging" = "true" ]; then
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-staging-fixes-r1.patch' && _patchmsg="Using esync staging 3.16- compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    cd "${srcdir}"/"${_esyncsrcdir}"
	    _patchname='esync-compat-fixes-r1.patch' && _patchmsg="Using esync 3.16- compat fixes" && nonuser_patcher
	    cd "${srcdir}"/"${_winesrcdir}"

	    # if using a wine version that includes 57212f6, apply 3.14+ additional fixes
	    if git merge-base --is-ancestor 57212f64f8e4fef0c63c633940e13d407c0f2069 HEAD; then # kernel32: Add AttachConsole implementation
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r1.1.patch' && _patchmsg="Using esync 3.14+ additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi
	  fi

	  # apply esync patches
	  if ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	    echo -e "\nEsync-mainline" >> "$_where"/prepare.log
	    msg2 "Applying Esync patchset"
	    for _f in "${srcdir}"/"${_esyncsrcdir}"/*.patch; do
	      #msg2 "Applying ${_f}"
	      echo -e "\nApplying ${_f}" >> "$_where"/prepare.log
	      git apply -C1 --verbose < "${_f}" >> "$_where"/prepare.log 2>&1
	    done
	  fi

	  if git merge-base --is-ancestor b2a546c92dabee8ab1c3d5b9fecc84d99caf0e76 HEAD && ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then #  server: Introduce kernel_object struct for generic association between server and kernel objects.
	    _patchname='esync-no_kernel_obj_list.patch' && _patchmsg="Add no_kernel_obj_list object method to esync. (4.5+)" && nonuser_patcher
	  fi

	  # Fix for server-Desktop_Refcount and patchsets depending on it (ws2_32-WSACleanup, ws2_32-TransmitFile, server-Pipe_ObjectName)
	  if [ "$_use_staging" = "true" ]; then
	    if ! git merge-base --is-ancestor b2a546c92dabee8ab1c3d5b9fecc84d99caf0e76 HEAD; then #  server: Introduce kernel_object struct for generic association between server and kernel objects.
	      _patchname='esync-no_alloc_handle.patch' && _patchmsg="Using esync-no_alloc_handle patch to fix server-Desktop_Refcount ws2_32-WSACleanup ws2_32-TransmitFile server-Pipe_ObjectName with Esync enabled" && nonuser_patcher
	    fi
	  fi
	fi
	# /esync

	# Launch with dedicated gpu desktop entry patch
	if [ "$_launch_with_dedicated_gpu" = "true" ]; then
	  _patchname='launch-with-dedicated-gpu-desktop-entry.patch' && _patchmsg="Applied launch with dedicated gpu desktop entry patch" && nonuser_patcher
	fi

	# Low latency alsa audio - https://blog.thepoon.fr/osuLinuxAudioLatency/
	if [ "$_lowlatency_audio" = "true" ] && [ "$_use_staging" = "true" ]; then
	  _patchname='lowlatency_audio.patch' && _patchmsg="Applied low latency alsa audio patch" && nonuser_patcher
	fi

	# Low latency pulse/pipewire audio - https://blog.thepoon.fr/osuLinuxAudioLatency/
	if [ "$_lowlatency_audio_pulse" = "true" ]; then
	  if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor f77af3dd6324fadaf153062d77b51f755f71faea HEAD ); then
	    _patchname='lowlatency_audio_pulse.patch' && _patchmsg="Applied low latency pulse/pipewire audio patch" && nonuser_patcher
	  fi
	fi

	# The Sims 2 fix - https://bugs.winehq.org/show_bug.cgi?id=8051
	if [ "$_sims2_fix" = "true" ]; then
	  if git merge-base --is-ancestor d88f12950761e9ff8d125a579de6e743979f4945 HEAD; then
	    _patchname='sims_2-fix.patch' && _patchmsg="Applied The Sims 2 fix" && nonuser_patcher
	  elif git merge-base --is-ancestor 4de2da1d146248ed872ae45c30b8d485832f4ac8 HEAD; then
	    _patchname='sims_2-fix-4.2-.patch' && _patchmsg="Applied The Sims 2 fix (4.2 and lower)" && nonuser_patcher
	  else
	    _patchname='sims_2-fix-legacy.patch' && _patchmsg="Applied The Sims 2 fix (legacy)" && nonuser_patcher
	  fi
	fi

	# Python fix for <=3.18 (backported from zzhiyi's patches) - fix for python and needed for "The Sims 4" to work - replaces staging partial implementation - https://bugs.winehq.org/show_bug.cgi?id=44999
	if [ "$_318python_fix" = "true" ] && ! git merge-base --is-ancestor 3ebd2f0be30611e6cf00468c2980c5092f91b5b5 HEAD; then
	  _patchname='pythonfix.patch' && _patchmsg="Applied Python/The Sims 4 fix" && nonuser_patcher
	fi

	# Fix crashes or perf issues related to high core count setups - Fixed in 4.0 - https://bugs.winehq.org/show_bug.cgi?id=45453
	if [ "$_highcorecount_fix" = "true" ] && ! git merge-base --is-ancestor ed75a7b3443e79f9d63e97eeebcce2d2f40c507b HEAD; then
	  _patchname='high-core-count-fix.patch' && _patchmsg="Applied high core count fix" && nonuser_patcher
	fi

	# Workaround for Final Fantasy XIV Launcher 404 error - Thanks @varris1 ! - Fixed by d535df42f665a097ec721b10fb49d7b18f899be9 (4.10)
	if [ "$_ffxivlauncher_fix" = "true" ]; then
	  if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 9bf46d5ce608a97e264681d2637ff3105e42c363 HEAD ); then
	    _patchname='ffxiv-launcher-workaround.patch' && _patchmsg="Applied Final Fantasy XIV Launcher fix" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	    _patchname='ffxiv-launcher-workaround-9bf46d5.patch' && _patchmsg="Applied Final Fantasy XIV Launcher fix" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 4e6a477acd32651dd571205786132666505aeb5b HEAD ); then
	    _patchname='ffxiv-launcher-workaround-0c249e6.patch' && _patchmsg="Applied Final Fantasy XIV Launcher fix" && nonuser_patcher
	  else
	    _patchname='ffxiv-launcher-workaround-4e6a477.patch' && _patchmsg="Applied Final Fantasy XIV Launcher fix" && nonuser_patcher
	  fi
	fi

	# Fix for LoL 9.20+ crashing - https://bugs.winehq.org/show_bug.cgi?id=47198
	if [ "$_lol920_fix" = "true" ] && [ "$_use_staging" = "true" ]; then
	  if git merge-base --is-ancestor 3513a176fd325492e5b5e498e4eebf3f820f8cc6 HEAD; then
	    _patchname='leagueoflolfix.patch' && _patchmsg="Applied LoL 9.20+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  elif git merge-base --is-ancestor 7f144646ffac6f3632d0c39b217dbd433c1154a0 HEAD; then
	    _patchname='leagueoflolfix-3513a17.patch' && _patchmsg="Applied LoL 9.20+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  elif git merge-base --is-ancestor bd9a1e23f2a1eb97492ff977dcb0d96fde8ab2ad HEAD; then
	    _patchname='leagueoflolfix-7f14464.patch' && _patchmsg="Applied LoL 9.20+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  elif git merge-base --is-ancestor 98682cfd01aca9be2755e4279db87d54e3642f0b HEAD; then
	    _patchname='leagueoflolfix-bd9a1e2.patch' && _patchmsg="Applied LoL 9.20+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  elif git merge-base --is-ancestor 18273d5e71e25575bdbdba1d252df72be3373f6d HEAD; then
	    _patchname='leagueoflolfix-98682cf.patch' && _patchmsg="Applied LoL 9.20+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  elif git merge-base --is-ancestor b87256cd1db21a59484248a193b6ad12ca2853ca HEAD; then
	    _patchname='leagueoflolfix-18273d5.patch' && _patchmsg="Applied LoL 9.20+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  elif git merge-base --is-ancestor 3b16f35413f3a6641df42b782ead294f343e7d5e HEAD; then
	    _patchname='leagueoflolfix-b87256c.patch' && _patchmsg="Applied LoL 9.20+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  elif git merge-base --is-ancestor b8f0e32b9f00f63abee6ca31e190ff794c053b67 HEAD; then
	    _patchname='leagueoflolfix-3b16f35.patch' && _patchmsg="Applied LoL 9.20+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  elif git merge-base --is-ancestor 39138478fdd93cc0dfc1e83b85784bc468e8d237 HEAD; then
	    _patchname='leagueoflolfix-b8f0e32.patch' && _patchmsg="Applied LoL 9.20+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  elif git merge-base --is-ancestor 944c4e8f760460ca6a260573d87c454052caad2c HEAD; then
	    _patchname='leagueoflolfix-3913847.patch' && _patchmsg="Applied LoL 9.20+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  else
	    _patchname='leagueoflolfix-944c4e8.patch' && _patchmsg="Applied LoL 9.20+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  fi
	fi

	# Fix for Assetto Corsa performance drop when HUD elements are displayed - https://bugs.winehq.org/show_bug.cgi?id=46955
	if [ "$_assettocorsa_hudperf_fix" = "true" ] && git merge-base --is-ancestor d19e34d8f072514cb903bda89767996ba078bae4 HEAD; then
	  if [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_unfrog" != "true" ]; then
	    _patchname='assettocorsa_hud_perf-proton.patch' && _patchmsg="Applied Assetto Corsa HUD performance fix (proton edition)" && nonuser_patcher
	  else
	    _patchname='assettocorsa_hud_perf.patch' && _patchmsg="Applied Assetto Corsa HUD performance fix" && nonuser_patcher
	  fi
	fi

	# Fix for Mortal Kombat 11 - Requires staging, native mfplat (win7) and a different GPU driver than RADV
	if [ "$_mk11_fix" = "true" ] && [ "$_use_staging" = "true" ] && [ "$_proton_fs_hack" = "true" ]; then
	  if git merge-base --is-ancestor 8504e40d5b5e7076b998b36e6291515b863482cb HEAD; then
	    _patchname='mk11.patch' && _patchmsg="Applied Mortal Kombat 11 fix" && nonuser_patcher
	  elif git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD; then
	    _patchname='mk11-8504e40.patch' && _patchmsg="Applied Mortal Kombat 11 fix" && nonuser_patcher
	  elif git merge-base --is-ancestor 75fb68e42423362ae945c0c0554f0dcd4d2e169b HEAD; then
	    _patchname='mk11-0c249e6.patch' && _patchmsg="Applied Mortal Kombat 11 fix" && nonuser_patcher
	  elif git merge-base --is-ancestor 84d85adeea578cac37bded97984409f44c7985ba HEAD; then
	    _patchname='mk11-75fb68e.patch' && _patchmsg="Applied Mortal Kombat 11 fix" && nonuser_patcher
	  elif git merge-base --is-ancestor 2ea3e40465f0530ad71c31e77c9727c00673d91f HEAD; then
	    _patchname='mk11-84d85ad.patch' && _patchmsg="Applied Mortal Kombat 11 fix" && nonuser_patcher
	  elif git merge-base --is-ancestor fb7cc99f8a8c5a1594cfa780807d5e75f4b9539e HEAD; then
	    _patchname='mk11-2ea3e40.patch' && _patchmsg="Applied Mortal Kombat 11 fix" && nonuser_patcher
	  elif git merge-base --is-ancestor 78e9b02cebf4b107aba69aa9a845ab661a7daf10 HEAD; then
	    _patchname='mk11-fb7cc99.patch' && _patchmsg="Applied Mortal Kombat 11 fix" && nonuser_patcher
	  elif git merge-base --is-ancestor b1c748c85205970b97cd31b4347a751c58b2d72e HEAD; then
	    _patchname='mk11-78e9b02.patch' && _patchmsg="Applied Mortal Kombat 11 fix" && nonuser_patcher
	  else
	    if [ "$_large_address_aware" = "true" ]; then
	      for _f in "$_where"/LAA-stagin*.patch ; do
	        patch "${_f}" << 'EOM'
@@ -220,15 +220,16 @@ diff --git a/dlls/ntdll/virtual.c b/dlls/ntdll/virtual.c
 index c008db78066..6163761a466 100644
 --- a/dlls/ntdll/virtual.c
 +++ b/dlls/ntdll/virtual.c
-@@ -2442,11 +2442,12 @@ void virtual_release_address_space(void)
+@@ -2442,12 +2442,13 @@ void virtual_release_address_space(void)
   *
   * Enable use of a large address space when allowed by the application.
   */
 -void virtual_set_large_address_space(void)
 +void virtual_set_large_address_space(BOOL force_large_address)
  {
      IMAGE_NT_HEADERS *nt = RtlImageNtHeader( NtCurrentTeb()->Peb->ImageBaseAddress );
  
+     if (is_win64) return;
 -    if (!(nt->FileHeader.Characteristics & IMAGE_FILE_LARGE_ADDRESS_AWARE)) return;
 +    if (!(nt->FileHeader.Characteristics & IMAGE_FILE_LARGE_ADDRESS_AWARE) && !force_large_address) return;
 +
EOM
	      done
	    fi
	    if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 89af635b941cf450ae371395e7b28d09161f3a36 HEAD ); then
	      _patchname='mk11-b1c748c.patch' && _patchmsg="Applied Mortal Kombat 11 fix (<b1c748c)" && nonuser_patcher
	    else
	      _patchname='mk11-89af635.patch' && _patchmsg="Applied Mortal Kombat 11 fix (<89af635)" && nonuser_patcher
	    fi
	  fi
	fi

	# apply wine-pba patchset
	if [ "$_use_pba" = "true" ]; then
	  if [ "$_pba_version" != "none" ]; then
	    _patchname="PBA${_pba_version}.patch" && _patchmsg="Using pba (${_pba_version}) patchset" && nonuser_patcher
	  fi
	fi

	# d3d9 patches
	if [ "$_use_legacy_gallium_nine" = "true" ] && [ "$_use_staging" = "true" ] && ! git merge-base --is-ancestor e24b16247d156542b209ae1d08e2c366eee3071a HEAD; then
	  wget -O "$_where"/wine-d3d9.patch https://raw.githubusercontent.com/sarnex/wine-d3d9-patches/master/wine-d3d9.patch
	  wget -O "$_where"/staging-helper.patch https://raw.githubusercontent.com/sarnex/wine-d3d9-patches/master/staging-helper.patch
	  patch -Np1 < "$_where"/staging-helper.patch
	  patch -Np1 < "$_where"/wine-d3d9.patch
	  autoreconf -f
	elif [ "$_use_legacy_gallium_nine" = "true" ] && [ "$_use_staging" != "true" ] && ! git merge-base --is-ancestor e24b16247d156542b209ae1d08e2c366eee3071a HEAD; then
	  wget -O "$_where"/wine-d3d9.patch https://raw.githubusercontent.com/sarnex/wine-d3d9-patches/master/wine-d3d9.patch
	  wget -O "$_where"/d3d9-helper.patch https://raw.githubusercontent.com/sarnex/wine-d3d9-patches/master/d3d9-helper.patch
	  patch -Np1 < "$_where"/d3d9-helper.patch
	  patch -Np1 < "$_where"/wine-d3d9.patch
	  autoreconf -f
	elif [ "$_use_legacy_gallium_nine" = "true" ] && git merge-base --is-ancestor e24b16247d156542b209ae1d08e2c366eee3071a HEAD; then
	  echo "Legacy Gallium Nine disabled due to known issues with selected Wine version" >> "$_where"/last_build_config.log
	fi

	# GLSL toggle patch - Allows for use of ARB instead of GLSL
	if [ "$_GLSL_toggle" = "true" ] && [ "$_use_staging" = "true" ] && [ "$_use_legacy_gallium_nine" != "true" ]; then
	  if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor ef11bb63ce54490bc5a1e14ab650207b515340da HEAD ); then
	    _patchname='GLSL-toggle.patch' && _patchmsg="Applied GLSL toggle patch" && nonuser_patcher
	  else
	    _patchname='GLSL-toggle-ef11bb6.patch' && _patchmsg="Applied GLSL toggle patch" && nonuser_patcher
	  fi
	fi

	# Set a custom fake refresh rate for virtual desktop
	if [ -n "$_fake_refresh_rate" ] && ( ! git merge-base --is-ancestor 6f305dd881e16f77f9eb183684d04b0b8746b769 HEAD || [ "$_proton_fs_hack" = "true" ] ); then
	  sed -i "s/999999/$_fake_refresh_rate/g" "${_where}/virtual_desktop_refreshrate.patch"
	  _patchname='virtual_desktop_refreshrate.patch' && _patchmsg="Applied custom fake virtual desktop refresh rate ($_fake_refresh_rate Hz) patch" && nonuser_patcher
	fi

	# fsync - experimental replacement for esync introduced with Proton 4.11-1
	if [ "$_use_fsync" = "true" ]; then
	  if [ "$_staging_esync" = "true" ]; then
	    if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 10ca57f4f56f86b433686afbdbe140ba54b239bb HEAD ); then
	      _patchname='fsync-unix-staging.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, staging)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 626870abe2e800cc9407d05d5c00500a4ad97b3a HEAD ); then
	      _patchname='fsync-unix-staging-10ca57f.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, staging)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 731339cd60c255fd5890063b144ad7c00661f5a0 HEAD ); then
	      _patchname='fsync-unix-staging-626870a.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, staging)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor d6ef9401b3ef05e87e0cadd31992a6809008331e HEAD ); then
	      _patchname='fsync-unix-staging-731339c.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, staging)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor c6f2aacb5761801a17b930086111f4b2c4a30075 HEAD ); then
	      _patchname='fsync-unix-staging-d6ef940.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, staging)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 44699c324f20690f9d6836919534ca1b5bcc3efe HEAD ); then
	      _patchname='fsync-unix-staging-c6f2aac.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, staging)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 2b6426da6550c50787eeb2b39affcb766e07ec11 HEAD ); then
	      _patchname='fsync-unix-staging-44699c3.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, staging)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor c1a042cefbc38eae6e0824a460a0657148e6745a HEAD ); then
	      _patchname='fsync-unix-staging-2b6426d.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, staging)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor dc77e28b0f7d6fdb11dafacb73b9889545359572 HEAD ); then
	      _patchname='fsync-unix-staging-c1a042c.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, staging)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 7bdc1d6bacaba02b914ca3b66ee239103201617d HEAD ); then
	      _patchname='fsync-unix-staging-3100197.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, staging)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 459d37643ef72d284eec0dc50573eff59935ae69 HEAD ); then
	      _patchname='fsync-unix-staging-7bdc1d6.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, staging)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	      _patchname='fsync-unix-staging-459d376.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, staging)" && nonuser_patcher
	    elif git merge-base --is-ancestor 27a52d0414b68eb9d74c058afc4775b43f151263 HEAD; then
	      _patchname='fsync-staging.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (staging)" && nonuser_patcher
	    elif git merge-base --is-ancestor 2633a5c1ae542f08f127ba737fa59fb03ed6180b HEAD; then
	      _patchname='fsync-staging-27a52d0.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (staging)" && nonuser_patcher
	    elif git merge-base --is-ancestor e5030a4ac0a303d6788ae79ffdcd88e66cf78bd2 HEAD; then
	      _patchname='fsync-staging-2633a5c.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (staging)" && nonuser_patcher
	    elif git merge-base --is-ancestor 40e849ffa46ae3cd060e2db83305dda1c4d2648e HEAD; then
	      _patchname='fsync-staging-e5030a4.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (staging)" && nonuser_patcher
	    elif git merge-base --is-ancestor 87012607688f730755ee91de14620e6e3b78395c HEAD; then
	      _patchname='fsync-staging-40e849f.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (staging)" && nonuser_patcher
	    elif git merge-base --is-ancestor fc17535eb98a4b200d6a418337a7e280568c7cfd HEAD; then
	      _patchname='fsync-staging-8701260.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (staging)" && nonuser_patcher
	    elif git merge-base --is-ancestor 608d086f1b1bb7168e9322c65224c23f34e75f29 HEAD; then
	      _patchname='fsync-staging-fc17535.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (staging <fc17535)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor cf04b8d6ac710c83dc9a433aea3e5d3c451095a1 HEAD ); then
	      _patchname='fsync-staging-608d086.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (staging <608d086)" && nonuser_patcher
	    elif git merge-base --is-ancestor 1d9a3f6d12322891a2af4aadd66a92ea66479233 HEAD; then
	      _patchname='fsync-staging-cf04b8d.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (staging <cf04b8d)" && nonuser_patcher
	    fi
	    if [[ ! ${_staging_args[*]} =~ "server-Desktop_Refcount" ]] && ( cd "${srcdir}"/"${_stgsrcdir}" && ! git merge-base --is-ancestor 7fc716aa5f8595e5bca9206f86859f1ac70894ad HEAD ); then
	      _patchname='fsync-staging-no_alloc_handle.patch' && _patchmsg="Added no_alloc_handle object method to fsync" && nonuser_patcher
	      if ([ "$_EXTERNAL_INSTALL" = "proton" ]) || [ "$_protonify" = "true" ] && git merge-base --is-ancestor 2633a5c1ae542f08f127ba737fa59fb03ed6180b HEAD; then
	        if git merge-base --is-ancestor d6ef9401b3ef05e87e0cadd31992a6809008331e HEAD; then
	          _patchname='server_Abort_waiting_on_a_completion_port_when_closing_it-no_alloc_handle.patch' && _patchmsg="Added Abort waiting on a completion port when closing it Proton patch (no_alloc_handle edition)" && nonuser_patcher
	        elif git merge-base --is-ancestor c6f2aacb5761801a17b930086111f4b2c4a30075 HEAD; then
	          _patchname='server_Abort_waiting_on_a_completion_port_when_closing_it-no_alloc_handle-d6ef940.patch' && _patchmsg="Added Abort waiting on a completion port when closing it Proton patch (no_alloc_handle edition)" && nonuser_patcher
	        else
	          _patchname='server_Abort_waiting_on_a_completion_port_when_closing_it-no_alloc_handle-c6f2aac.patch' && _patchmsg="Added Abort waiting on a completion port when closing it Proton patch (no_alloc_handle edition)" && nonuser_patcher
	        fi
	      fi
	    elif [ "$_protonify" = "true" ] && git merge-base --is-ancestor 2633a5c1ae542f08f127ba737fa59fb03ed6180b HEAD; then
	      if git merge-base --is-ancestor d6ef9401b3ef05e87e0cadd31992a6809008331e HEAD; then
	        _patchname='server_Abort_waiting_on_a_completion_port_when_closing_it.patch' && _patchmsg="Added Abort waiting on a completion port when closing it Proton patch" && nonuser_patcher
	      elif git merge-base --is-ancestor c6f2aacb5761801a17b930086111f4b2c4a30075 HEAD; then
	        _patchname='server_Abort_waiting_on_a_completion_port_when_closing_it-d6ef940.patch' && _patchmsg="Added Abort waiting on a completion port when closing it Proton patch" && nonuser_patcher
	      else
	        _patchname='server_Abort_waiting_on_a_completion_port_when_closing_it-c6f2aac.patch' && _patchmsg="Added Abort waiting on a completion port when closing it Proton patch" && nonuser_patcher
	      fi
	    fi
	  elif [ "$_use_esync" = "true" ]; then
	    if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 10ca57f4f56f86b433686afbdbe140ba54b239bb HEAD ); then
	      _patchname='fsync-unix-mainline.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, mainline)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 731339cd60c255fd5890063b144ad7c00661f5a0 HEAD ); then
	      _patchname='fsync-unix-mainline-10ca57f.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, mainline)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor d6ef9401b3ef05e87e0cadd31992a6809008331e HEAD ); then
	      _patchname='fsync-unix-mainline-731339c.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, mainline)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor c6f2aacb5761801a17b930086111f4b2c4a30075 HEAD ); then
	      _patchname='fsync-unix-mainline-d6ef940.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, mainline)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 44699c324f20690f9d6836919534ca1b5bcc3efe HEAD ); then
	      _patchname='fsync-unix-mainline-c6f2aac.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, mainline)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 2b6426da6550c50787eeb2b39affcb766e07ec11 HEAD ); then
	      _patchname='fsync-unix-mainline-44699c3.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, mainline)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor c1a042cefbc38eae6e0824a460a0657148e6745a HEAD ); then
	      _patchname='fsync-unix-mainline-2b6426d.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, mainline)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 310019789f7bde12ae3f25f723957c975fb2f804 HEAD ); then
	      _patchname='fsync-unix-mainline-c1a042c.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, mainline)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor cf49617c1a378dd4a37ab7226187708c501b046f HEAD ); then
	      _patchname='fsync-unix-mainline-3100197.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, mainline)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 459d37643ef72d284eec0dc50573eff59935ae69 HEAD ); then
	      _patchname='fsync-unix-mainline-7bdc1d6.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, mainline)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	      _patchname='fsync-unix-mainline-459d376.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (unix, mainline)" && nonuser_patcher
	    elif git merge-base --is-ancestor 2633a5c1ae542f08f127ba737fa59fb03ed6180b HEAD; then
	      _patchname='fsync-mainline.patch' && _patchmsg="Applied fsync, an experimental replacement for esync" && nonuser_patcher
	    elif git merge-base --is-ancestor e5030a4ac0a303d6788ae79ffdcd88e66cf78bd2 HEAD; then
	      _patchname='fsync-mainline-2633a5c.patch' && _patchmsg="Applied fsync, an experimental replacement for esync" && nonuser_patcher
	    elif git merge-base --is-ancestor 40e849ffa46ae3cd060e2db83305dda1c4d2648e HEAD; then
	      _patchname='fsync-mainline-e5030a4.patch' && _patchmsg="Applied fsync, an experimental replacement for esync" && nonuser_patcher
	    elif git merge-base --is-ancestor 87012607688f730755ee91de14620e6e3b78395c HEAD; then
	      _patchname='fsync-mainline-40e849f.patch' && _patchmsg="Applied fsync, an experimental replacement for esync" && nonuser_patcher
	    elif git merge-base --is-ancestor fc17535eb98a4b200d6a418337a7e280568c7cfd HEAD; then
	      _patchname='fsync-mainline-8701260.patch' && _patchmsg="Applied fsync, an experimental replacement for esync" && nonuser_patcher
	    elif git merge-base --is-ancestor 608d086f1b1bb7168e9322c65224c23f34e75f29 HEAD; then
	      _patchname='fsync-mainline-fc17535.patch' && _patchmsg="Applied fsync, an experimental replacement for esync" && nonuser_patcher
	    elif git merge-base --is-ancestor 29914d583fe098521472332687b8da69fc692690 HEAD; then
	      _patchname='fsync-mainline-608d086.patch' && _patchmsg="Applied fsync, an experimental replacement for esync" && nonuser_patcher
	    fi
	  else
	    echo "Fsync forcefully disabled due to incompatible tree" >> "$_where"/last_build_config.log
	  fi
	  if [ "$_fsync_spincounts" = "true" ] && [ "$_use_staging" = "true" ] && ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 8b2fd051c97187c68dee2ba2f0df7aca65c4cca6 HEAD ) && ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then # Temporarily only allow on staging - we depend on esync mutexes abandonment
	    _patchname='fsync-spincounts.patch' && _patchmsg="Add a configurable spin count to fsync" && nonuser_patcher
	  fi

	  # futex_waitv
	  if [ "$_staging_esync" = "true" ] || [ "$_use_esync" = "true" ]; then
	    if [ "$_fsync_futex_waitv" = "true" ] && ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	      _patchname='fsync_futex_waitv.patch' && _patchmsg="Replace all fsync interfaces with futex_waitv" && nonuser_patcher
	      _fsync_futex2="false"
	    fi
	  fi

	  # futex2
	  if [ "$_staging_esync" = "true" ] || [ "$_use_esync" = "true" ]; then
	    if [ "$_fsync_futex2" = "true" ] && ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	      _patchname='fsync_futex2.patch' && _patchmsg="Add futex2 support to fsync" && nonuser_patcher
	    fi
	  fi
	fi

	echo -e "" >> "$_where"/last_build_config.log

	# Legacy Proton Fullscreen inline patching
	if [ "$_proton_rawinput" = "true" ] && [ "$_proton_fs_hack" = "true" ] && [ "$_use_staging" = "true" ] && ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 938dddf7df920396ac3b30a44768c1582d0c144f HEAD ); then
	  echo -e "\nLegacy Proton Fullscreen inline patching" >> "$_where"/prepare.log
	  for _f in "$_where"/valve_proton_fullscreen_hack-staging-{938dddf,de64501,82c6ec3,7cc69d7,0cb79db,a4b9460,57bb5cc,6e87235}.patch; do
	    patch "${_f}" >> "$_where"/prepare.log << 'EOM'
@@ -2577,7 +2577,7 @@ index 1209a250b0..077c18ac10 100644
 +    input.u.mi.dx = pt.x;
 +    input.u.mi.dy = pt.y;
 +
-     TRACE( "pos %d,%d (event %f,%f, accum %f,%f)\n", input.u.mi.dx, input.u.mi.dy, dx, dy, x_rel->accum, y_rel->accum );
+     TRACE( "pos %d,%d (event %f,%f)\n", input.u.mi.dx, input.u.mi.dy, dx, dy );
  
      input.type = INPUT_MOUSE;
 diff --git a/dlls/winex11.drv/opengl.c b/dlls/winex11.drv/opengl.c
EOM
      done
	fi

	# Proton Fullscreen patch - Allows resolution changes for fullscreen games without changing desktop resolution
	if [ "$_proton_fs_hack" = "true" ] && [ "$_unfrog" != "true" ]; then
	  if [ "$_FS_bypass_compositor" != "true" ] && [ "$_FS_bypass_compositor_legacy" != "false" ]; then
	    _patchname='FS_bypass_compositor.patch' && _patchmsg="Applied Fullscreen compositor bypass patch" && nonuser_patcher
	  fi
	  if [ "$_use_staging" = "true" ]; then
	    if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor c9c7130f3cc51c1861a5ef3e703fd442e8942ba4 HEAD ); then
	      _patchname='valve_proton_fullscreen_hack-staging.patch' && _patchmsg="Applied Proton fullscreen hack patch (staging)" && nonuser_patcher
	    else
	      if git merge-base --is-ancestor a7ec245f844762cce6fb789fe3ffb1bf42d44249 HEAD; then
	        _lastcommit="c9c7130"
	      elif git merge-base --is-ancestor f46c4a3920ce8e96b37b606c207add7f596f1950 HEAD; then
	        _lastcommit="a7ec245"
	      elif git merge-base --is-ancestor 8285f616030f27877922ff414530d4f909306ace HEAD; then
	        _lastcommit="f46c4a3"
	      elif git merge-base --is-ancestor 211da181c9140541ab7f7fcfa479367b3f7783eb HEAD; then
	        _lastcommit="8285f61"
	      elif git merge-base --is-ancestor 9561af9a7d8d77e2f98341e278c842226cae47ed HEAD; then
	        _lastcommit="211da18"
	      elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor a71e4cdf85fae1282d7cab042fabd66e407d11d6 HEAD ); then
	        _lastcommit="9561af9"
	      elif git merge-base --is-ancestor 454712a94d62849324d20014c786b0e7c452bf61 HEAD; then
	        _lastcommit="a71e4cd"
	      elif git merge-base --is-ancestor a92ab08688b1e425c887ccb77196bbf681f24be1 HEAD; then
	        _lastcommit="454712a"
	      elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 7f18df46333b5686f2e3622ebc474530e15c6888 HEAD ); then
	        _lastcommit="a92ab08"
	      elif git merge-base --is-ancestor 011fabb2c43d13402ea18b6ea7be3669b5e6c7a8 HEAD; then
	        _lastcommit="7f18df4"
	      elif git merge-base --is-ancestor 6d04e6c3a9c4c8b1cc2d1ba337c33cc56d1a8ab2 HEAD; then
	        _lastcommit="011fabb"
	      elif git merge-base --is-ancestor 62cb6ace2cfe46358e6526868145a5bd8a7f990b HEAD; then
	        _lastcommit="6d04e6c"
	      elif git merge-base --is-ancestor a27d5bae114eef5352b699ee38975bc8793b4dcb HEAD; then
	        _lastcommit="62cb6ac"
	      elif git merge-base --is-ancestor a24bdfc2c69c5648cbb3df762149b2647e209a09 HEAD; then
	        _lastcommit="a27d5ba"
	      elif git merge-base --is-ancestor 0f972e2247932f255f131792724e4796b4b2b87a HEAD; then
	        _lastcommit="a24bdfc"
	      elif git merge-base --is-ancestor 1e074c39f635c585595e9f3ece99aa290a7f9cf8 HEAD; then
	        _lastcommit="0f972e2"
	      elif git merge-base --is-ancestor 1e074c39f635c585595e9f3ece99aa290a7f9cf8 HEAD; then
	        _lastcommit="af3d292"
	      elif git merge-base --is-ancestor 314cd9cdd542db658ce7a01ef0a7621fc2d9d335 HEAD; then
	        _lastcommit="1e074c3"
	      elif git merge-base --is-ancestor 5dd03cbc8f5cc8fa349d1ce0f155139094eff56c HEAD; then
	        _lastcommit="314cd9c"
	      elif git merge-base --is-ancestor 408a5a86ec30e293bf9e6eec4890d552073a82e8 HEAD; then
	        _lastcommit="5dd03cb"
	      elif git merge-base --is-ancestor 3db619d46e70a398a06001573fb42b0a32d81209 HEAD; then
	        _lastcommit="408a5a8"
	      elif git merge-base --is-ancestor 707fcb99a60015fcbb20c83e9031bc5be7a58618 HEAD; then
	        _lastcommit="3db619d"
	      elif git merge-base --is-ancestor b0e2d046fc69cc4a4c5aefe383793950b44a1a7b HEAD; then
	        _lastcommit="707fcb9"
	      elif git merge-base --is-ancestor 594814c00ab059d9686ed836b1865f8a94859c8a HEAD; then
	        _lastcommit="b0e2d04"
	      elif git merge-base --is-ancestor 086c686e817a596e35c41dd5b37f3c28587af9d5 HEAD; then
	        _lastcommit="594814c"
	      elif git merge-base --is-ancestor 74dc0c5df9c3094352caedda8ebe14ed2dfd615e HEAD; then
	        _lastcommit="086c686"
	      elif git merge-base --is-ancestor aee91dc4ac08428e74fbd21f97438db38f84dbe5 HEAD; then
	        _lastcommit="74dc0c5"
	      elif git merge-base --is-ancestor 7e736b5903d3d078bbf7bb6a509536a942f6b9a0 HEAD; then
	        _lastcommit="aee91dc"
	      elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 734918298c4a6eb1cb23f31e21481f2ef58a0970 HEAD ); then
	        _lastcommit="7e736b5"
	      elif git merge-base --is-ancestor de6450135de419ac7e64aee0c0efa27b60bea3e8 HEAD; then
	        _lastcommit="938dddf"
	      elif git merge-base --is-ancestor 82c6ec3a32f44e8b3e0cc88b7f10e0c0d7fa1b89 HEAD; then
	        _lastcommit="de64501"
	      elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 7cc69d770780b8fb60fb249e007f1a777a03e51a HEAD ); then
	        _lastcommit="82c6ec3"
	      elif git merge-base --is-ancestor 0cb79db12ac7c48477518dcff269ccc5d6b745e0 HEAD; then
	        _lastcommit="7cc69d7"
	      elif git merge-base --is-ancestor a4b9460ad68bad6675f9e50b390503db9ef94d6b HEAD; then
	        _lastcommit="0cb79db"
	      elif git merge-base --is-ancestor 57bb5cce75aed1cb06172cc0b6b696dfb008e7c1 HEAD; then
	        _lastcommit="a4b9460"
	      elif git merge-base --is-ancestor 6e87235523f48d523285409dcbbd7885df9948d0 HEAD; then
	        _lastcommit="57bb5cc"
	      else
	        _lastcommit="6e87235"
          fi
	      _patchname="valve_proton_fullscreen_hack-staging-$_lastcommit.patch" && _patchmsg="Applied Proton fullscreen hack patch ($_lastcommit)" && nonuser_patcher
	    fi
	  else
	    if git merge-base --is-ancestor af3d292343034b87403b1c8738e29bd3479fe87e HEAD; then
	      _patchname='valve_proton_fullscreen_hack.patch' && _patchmsg="Applied Proton fullscreen hack patch (mainline)" && nonuser_patcher
	    elif git merge-base --is-ancestor 1e074c39f635c585595e9f3ece99aa290a7f9cf8 HEAD; then
	      _patchname='valve_proton_fullscreen_hack-af3d292.patch' && _patchmsg="Applied Proton fullscreen hack patch (mainline)" && nonuser_patcher
	    elif git merge-base --is-ancestor 314cd9cdd542db658ce7a01ef0a7621fc2d9d335 HEAD; then
	      _patchname='valve_proton_fullscreen_hack-1e074c3.patch' && _patchmsg="Applied Proton fullscreen hack patch (mainline)" && nonuser_patcher
	    elif git merge-base --is-ancestor 5dd03cbc8f5cc8fa349d1ce0f155139094eff56c HEAD; then
	      _patchname='valve_proton_fullscreen_hack-314cd9c.patch' && _patchmsg="Applied Proton fullscreen hack patch (mainline)" && nonuser_patcher
	    elif git merge-base --is-ancestor 408a5a86ec30e293bf9e6eec4890d552073a82e8 HEAD; then
	      _patchname='valve_proton_fullscreen_hack-5dd03cb.patch' && _patchmsg="Applied Proton fullscreen hack patch (mainline)" && nonuser_patcher
	    elif git merge-base --is-ancestor 3db619d46e70a398a06001573fb42b0a32d81209 HEAD; then
	      _patchname='valve_proton_fullscreen_hack-408a5a8.patch' && _patchmsg="Applied Proton fullscreen hack patch (mainline)" && nonuser_patcher
	    elif git merge-base --is-ancestor 707fcb99a60015fcbb20c83e9031bc5be7a58618 HEAD; then
	      _patchname='valve_proton_fullscreen_hack-3db619d.patch' && _patchmsg="Applied Proton fullscreen hack patch (mainline)" && nonuser_patcher
	    elif git merge-base --is-ancestor b0e2d046fc69cc4a4c5aefe383793950b44a1a7b HEAD; then
	      _patchname='valve_proton_fullscreen_hack-707fcb9.patch' && _patchmsg="Applied Proton fullscreen hack patch (mainline)" && nonuser_patcher
	    elif git merge-base --is-ancestor 594814c00ab059d9686ed836b1865f8a94859c8a HEAD; then
	      _patchname='valve_proton_fullscreen_hack-b0e2d04.patch' && _patchmsg="Applied Proton fullscreen hack patch (mainline)" && nonuser_patcher
	    elif git merge-base --is-ancestor 086c686e817a596e35c41dd5b37f3c28587af9d5 HEAD; then
	      _patchname='valve_proton_fullscreen_hack-594814c.patch' && _patchmsg="Applied Proton fullscreen hack patch (mainline)" && nonuser_patcher
	    elif git merge-base --is-ancestor 74dc0c5df9c3094352caedda8ebe14ed2dfd615e HEAD; then
	      _patchname='valve_proton_fullscreen_hack-086c686.patch' && _patchmsg="Applied Proton fullscreen hack patch (mainline <086c686)" && nonuser_patcher
	    elif git merge-base --is-ancestor aee91dc4ac08428e74fbd21f97438db38f84dbe5 HEAD; then
	      _patchname='valve_proton_fullscreen_hack-74dc0c5.patch' && _patchmsg="Applied Proton fullscreen hack patch (mainline <74dc0c5)" && nonuser_patcher
	    else
	      _proton_fs_hack="false"
	    fi
	  fi
	  if [ "$_FS_bypass_compositor" != "true" ] && [ "$_FS_bypass_compositor_legacy" != "false" ]; then
	    _FS_bypass_compositor="true"
	    _patchname='FS_bypass_compositor-disabler.patch' && _patchmsg="Turned off Fullscreen compositor bypass" && nonuser_patcher
	  fi
	  # Legacy split realmodes patchset
	  if ( cd "${srcdir}"/"${_stgsrcdir}" && ! git merge-base --is-ancestor 734918298c4a6eb1cb23f31e21481f2ef58a0970 HEAD ); then
	    _patchname='valve_proton_fullscreen_hack_realmodes.patch' && _patchmsg="Using real modes in FS hack addon" && nonuser_patcher
	  fi
	fi

	# Proton compatible rawinput patchset
	if [ "$_proton_rawinput" = "true" ] && [ "$_proton_fs_hack" = "true" ] && [ "$_use_staging" = "true" ] && git merge-base --is-ancestor cfcc280905b7804efde8f42bcd6bddbe5ebd8cad HEAD; then
	  if git merge-base --is-ancestor 3a9edf9aad43c3e8ba724571da5381f821f1dc56 HEAD; then
	    _patchname='proton-rawinput.patch' && _patchmsg="Using rawinput patchset" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 82cff8bbdbc133cc14cdb9befc36c61c3e49c242 HEAD ); then
	    _patchname='proton-rawinput-3a9edf9.patch' && _patchmsg="Using rawinput patchset" && nonuser_patcher
	  elif git merge-base --is-ancestor 306c40e67319cae8e4c448ec8fc8d3996f87943f HEAD; then
	    _patchname='proton-rawinput-27a52d0.patch' && _patchmsg="Using rawinput patchset" && nonuser_patcher
	  elif git merge-base --is-ancestor d5fd3c8a386cf716b1a9695069462be0abd0fa4f HEAD; then
	    _patchname='proton-rawinput-306c40e.patch' && _patchmsg="Using rawinput patchset" && nonuser_patcher
	  elif git merge-base --is-ancestor dbe7694c533ce8bc454248255a2abad66f221e01 HEAD; then
	    _patchname='proton-rawinput-d5fd3c8.patch' && _patchmsg="Using rawinput patchset" && nonuser_patcher
	  elif git merge-base --is-ancestor 19c6524e48db1d785095953d25591f1e2d2872d9 HEAD; then
	    _patchname='proton-rawinput-dbe7694.patch' && _patchmsg="Using rawinput patchset (<19c6524)" && nonuser_patcher
	  elif git merge-base --is-ancestor 74dc0c5df9c3094352caedda8ebe14ed2dfd615e HEAD; then
	    _patchname='proton-rawinput-19c6524.patch' && _patchmsg="Using rawinput patchset (<19c6524)" && nonuser_patcher
	  else
	    _patchname='proton-rawinput-74dc0c5.patch' && _patchmsg="Using rawinput patchset (<74dc0c5)" && nonuser_patcher
	  fi
	  if [[ ! ${_staging_userargs[*]} =~ "winex11-key_translation" ]] && ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 8218a789558bf074bd26a9adf3bbf05bdb9cb88e HEAD && ! git merge-base --is-ancestor 82cff8bbdbc133cc14cdb9befc36c61c3e49c242 HEAD ); then # Apply staging winex11-key_translation patchset post staging-application when enabled
	      cp -u "${srcdir}"/"${_stgsrcdir}"/patches/winex11-key_translation/*.patch "$_where"/ && ln -s -f "${srcdir}"/"${_stgsrcdir}"/patches/winex11-key_translation/*.patch "${srcdir}"/
	      _patchname='0001-winex11-Match-keyboard-in-Unicode.patch' && _patchmsg="Applied proton friendly winex11-Match-keyboard-in-Unicode" && nonuser_patcher
	      _patchname='0002-winex11-Fix-more-key-translation.patch' && _patchmsg="Applied proton friendly winex11-Fix-more-key-translation" && nonuser_patcher
	      _patchname='0003-winex11.drv-Fix-main-Russian-keyboard-layout.patch' && _patchmsg="Applied proton friendly winex11.drv-Fix-main-Russian-keyboard-layout" && nonuser_patcher
	  fi
	fi

	# Update winevulkan
	if [ "$_update_winevulkan" = "true" ] && git merge-base --is-ancestor ad82739dda15b44510f6003302f0ad17848a35a7 HEAD && ! git merge-base --is-ancestor 7e736b5903d3d078bbf7bb6a509536a942f6b9a0 HEAD; then
	  if [ "$_proton_fs_hack" = "true" ] && [ "$_use_staging" = "true" ]; then
	    _patchname='winevulkan-1.1.113-proton.patch' && _patchmsg="Applied winevulkan 1.1.113 patch (proton edition)" && nonuser_patcher
	  else
	    _patchname='winevulkan-1.1.113.patch' && _patchmsg="Applied winevulkan 1.1.113 patch" && nonuser_patcher
	  fi
	fi

	# Overwatch mf crash fix from Guy1524 - https://bugs.winehq.org/show_bug.cgi?id=47385 - Fixed in b182ba88
	if [ "$_OW_fix" = "true" ] && git merge-base --is-ancestor 9bf4db1325d303a876bf282543289e15f9c698ad HEAD && ! git merge-base --is-ancestor b182ba882cfcce7b8769470f49f0fba216095c45 HEAD; then
	   _patchname='overwatch-mfstub.patch' && _patchmsg="Applied Overwatch mf crash fix" && nonuser_patcher
	fi

	# Magic The Gathering: Arena crash fix - (>aa0c4bb5e72caf290b6588bc1f9931cc89a9feb6)
	if [ "$_mtga_fix" = "true" ] && git merge-base --is-ancestor aa0c4bb5e72caf290b6588bc1f9931cc89a9feb6 HEAD && ! git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD; then
	  if git merge-base --is-ancestor c3fac6e36caab168974dd04a60ae1bbb1a0fd919 HEAD; then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='mtga-staging.patch' && _patchmsg="Applied MTGA crashfix" && nonuser_patcher
	    else
	      _patchname='mtga-mainline.patch' && _patchmsg="Applied MTGA crashfix" && nonuser_patcher
	    fi
	  else
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='mtga-staging-c3fac6e.patch' && _patchmsg="Applied MTGA crashfix" && nonuser_patcher
	    else
	      _patchname='mtga-mainline-c3fac6e.patch' && _patchmsg="Applied MTGA crashfix" && nonuser_patcher
	    fi
	  fi
	fi

	# Workarounds to prevent crashes on some mf functions
	if ! git merge-base --is-ancestor 437bc14ac352df8b34819f7df6aab0b0fb04dddd HEAD; then
	  if [ "$_use_staging" = "true" ] && [ "$_proton_mf_hacks" = "true" ] && git merge-base --is-ancestor b182ba882cfcce7b8769470f49f0fba216095c45 HEAD; then
	    if git merge-base --is-ancestor e308d81a617632fe0fedd243952f79e8d9ec05b4 HEAD; then
	      _patchname='proton_mf_hacks.patch' && _patchmsg="Applied proton mf hacks patch" && nonuser_patcher
	    elif git merge-base --is-ancestor f540d1615fe66c95a3824e86e5292a026511749e HEAD; then
	      _patchname='proton_mf_hacks-e308d81.patch' && _patchmsg="Applied proton mf hacks patch" && nonuser_patcher
	    elif git merge-base --is-ancestor 120505ed6b590daea11486a512dd563600d0329f HEAD; then
	      _patchname='proton_mf_hacks-f540d16.patch' && _patchmsg="Applied proton mf hacks patch" && nonuser_patcher
	    elif git merge-base --is-ancestor 7c5fcfffe7b3a001c980f19cb6ed1cee049c26c8 HEAD; then
	      _patchname='proton_mf_hacks-120505e.patch' && _patchmsg="Applied proton mf hacks patch" && nonuser_patcher
	    else
	      _patchname='proton_mf_hacks-7c5fcff.patch' && _patchmsg="Applied proton mf hacks patch" && nonuser_patcher
	    fi
	  fi
	fi

	# Enable STAGING_SHARED_MEMORY by default - https://wiki.winehq.org/Wine-Staging_Environment_Variables#Shared_Memory
	if [ "$_stg_shared_mem_default" = "true" ] && [ "$_use_staging" = "true" ] && ( cd "${srcdir}"/"${_stgsrcdir}" && ! git merge-base --is-ancestor 06877e55b1100cc49d3726e9a70f31c4dfbe66f8 HEAD ); then
	  _patchname='enable_stg_shared_mem_def.patch' && _patchmsg="Enable STAGING_SHARED_MEMORY by default" && nonuser_patcher
	fi

	# Nvidia hate - Prevents building of nvapi/nvapi64, nvcuda, nvcuvid and nvencodeapi/nvencodeapi64 libs
	if [ "$_nvidia_hate" = "true" ] && [ "$_use_staging" = "true" ]; then
	  _patchname='nvidia-hate.patch' && _patchmsg="Hatin' on novideo" && nonuser_patcher
	fi

	# Revert moving various funcs to kernelbase & ntdll to fix some dll loading issues and ntdll crashes (with Cemu and Blizzard games notably)
	if [ "$_kernelbase_reverts" = "true" ] || [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_unfrog" != "true" ] && git merge-base --is-ancestor 8d25965e12717b266f2fc74bb10d915234d16772 HEAD && ! git merge-base --is-ancestor b7db0b52cee65a008f503ce727befcad3ba8d28a HEAD; then
	  if git merge-base --is-ancestor 461b5e56f95eb095d97e4af1cb1c5fd64bb2862a HEAD; then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='proton-tkg-staging-kernelbase-reverts.patch' && _patchmsg="Using kernelbase reverts patch (staging)" && nonuser_patcher
	    else
	      _patchname='proton-tkg-kernelbase-reverts.patch' && _patchmsg="Using kernelbase reverts patch" && nonuser_patcher
	    fi
	  else
	    if git merge-base --is-ancestor fd3735cf4dd55b5c582bd51bb03647e5eaf12847 HEAD; then
	      _lastcommit="461b5e5"
	    elif git merge-base --is-ancestor c258b5ef1100c8c238aab0a17ca743a326829aac HEAD; then
	      _lastcommit="fd3735c"
	    elif git merge-base --is-ancestor 9551cb0b84dc0c0c9c1778cc37d7bafef4fd4299 HEAD; then
	      _lastcommit="c258b5e"
	    elif git merge-base --is-ancestor 8d25965e12717b266f2fc74bb10d915234d16772 HEAD; then
	      _lastcommit="9551cb0"
	    else
	      _lastcommit="none"
	    fi
	    if [ "$_lastcommit" != "none" ]; then
	      if [ "$_use_staging" = "true" ]; then
	        _patchname="proton-tkg-staging-kernelbase-reverts-$_lastcommit.patch" && _patchmsg="Using kernelbase reverts patch (staging) (<$_lastcommit)" && nonuser_patcher
	      else
	        _patchname="proton-tkg-kernelbase-reverts-$_lastcommit.patch" && _patchmsg="Using kernelbase reverts patch (<$_lastcommit)" && nonuser_patcher
	      fi
	    fi
	  fi
	fi

	# IMAGE_FILE_LARGE_ADDRESS_AWARE override - Enable with WINE_LARGE_ADDRESS_AWARE=1
	if [ "$_large_address_aware" = "true" ]; then
	  if git merge-base --is-ancestor c998667bf0983ef99cc48847d3d6fc6ca6ff4a2d HEAD && ! git merge-base --is-ancestor 9f0d66923933d82ae0b09fe5d84f977c1a657cc1 HEAD; then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='legacy-LAA-staging.patch' && _patchmsg="Applied large address aware override support (legacy)" && nonuser_patcher
	    else
	      _patchname='legacy-LAA.patch' && _patchmsg="Applied large address aware override support (legacy)" && nonuser_patcher
	    fi
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor ea6308e364b669adfcb8b1e448c8b08d715bcf6d HEAD ); then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='LAA-unix-staging.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    else
	      _patchname='LAA-unix.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    fi
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor ac3ec2d955573e187413743428ee7e4d1a6906d5 HEAD ); then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='LAA-unix-staging-ea6308e.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    else
	      _patchname='LAA-unix-ea6308e.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    fi
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 72c562ce9c481e73a01f50e17b624095aab11bdc HEAD ); then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='LAA-unix-staging-ac3ec2d.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    else
	      _patchname='LAA-unix-ac3ec2d.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    fi
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 7512c53b89308c16a512cb8f0c1d0fd6ff02b17b HEAD ); then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='LAA-unix-staging-72c562c.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    else
	      _patchname='LAA-unix-72c562c.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    fi
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='LAA-unix-staging-7512c53.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    else
	      _patchname='LAA-unix-7512c53.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    fi
	  elif git merge-base --is-ancestor 18411a19b4ea3a68234980c56d4c252670dfc000 HEAD; then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='LAA-staging.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    else
	      _patchname='LAA.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    fi
	  elif git merge-base --is-ancestor 608d086f1b1bb7168e9322c65224c23f34e75f29 HEAD; then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='LAA-staging-18411a1.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    else
	      _patchname='LAA-18411a1.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    fi
	  elif git merge-base --is-ancestor 9f0d66923933d82ae0b09fe5d84f977c1a657cc1 HEAD; then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='LAA-staging-608d086.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    else
	      _patchname='LAA-608d086.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	    fi
	  fi
	fi

	# Proton/fs-hack friendly winex11-MWM_Decorations
	if [ "$_proton_fs_hack" = "true" ] && [ "$_use_staging" = "true" ] && git merge-base --is-ancestor 8000b5415d2c249176bda3d8b49f8fc9978e1623 HEAD && ! git merge-base --is-ancestor 0f972e2247932f255f131792724e4796b4b2b87a HEAD; then
	  _patchname='proton-staging_winex11-MWM_Decorations.patch' && _patchmsg="Applied proton friendly winex11-MWM_Decorations" && nonuser_patcher
	fi

	if [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_unfrog" != "true" ]; then
	  if [ "$_proton_fs_hack" != "true" ] && [ "$_use_staging" = "true" ] && [[ ! ${_staging_userargs[*]} =~ "winex11-key_translation" ]] && ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 8218a789558bf074bd26a9adf3bbf05bdb9cb88e HEAD && ! git merge-base --is-ancestor 82cff8bbdbc133cc14cdb9befc36c61c3e49c242 HEAD ); then
	    _patchname='staging-winex11-key_translation.patch' && _patchmsg="Applied non-fshack friendly staging winex11-key_translation patchset" && nonuser_patcher
	  fi
	  if [ "$_steamclient_noswap" != "true" ] && git merge-base --is-ancestor b7db0b52cee65a008f503ce727befcad3ba8d28a HEAD; then
	    if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 1b9ada6cabd04ccb02c4ddcc82a53e62ea477948 HEAD ); then
	      _patchname='proton-tkg-steamclient-swap.patch' && _patchmsg="Applied steamclient substitution hack" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 72449b76e8e40f1690762545fd2c0021647da140 HEAD ); then
	      _patchname='proton-tkg-steamclient-swap-1b9ada6.patch' && _patchmsg="Applied steamclient substitution hack" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 3190a5bcdd7fc043cf54ac070a5f602cb9dd140f HEAD ); then
	      _patchname='proton-tkg-steamclient-swap-72449b7.patch' && _patchmsg="Applied steamclient substitution hack" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 5071a287437e624d2318a71218cb247522ac0d43 HEAD ); then
	      _patchname='proton-tkg-steamclient-swap-3190a5b.patch' && _patchmsg="Applied steamclient substitution hack" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor b572cf30253b0922c7c476bfc666c0345eb50256 HEAD ); then
	      _patchname='proton-tkg-steamclient-swap-5071a28.patch' && _patchmsg="Applied steamclient substitution hack" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor c2d84da8134cc9d07a114561c10c75bf91078370 HEAD ); then
	      _patchname='proton-tkg-steamclient-swap-b572cf3.patch' && _patchmsg="Applied steamclient substitution hack" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 4ea07a30ce25e63ba61012ec9886ffc636e70bbb HEAD ); then
	      _patchname='proton-tkg-steamclient-swap-c2d84da.patch' && _patchmsg="Applied steamclient substitution hack" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	      _patchname='proton-tkg-steamclient-swap-4ea07a3.patch' && _patchmsg="Applied steamclient substitution hack" && nonuser_patcher
	    elif git merge-base --is-ancestor 09db718d99026959c8bcf0718dccad589cad34f3 HEAD; then
	      _patchname='proton-tkg-steamclient-swap-de679af.patch' && _patchmsg="Applied steamclient substitution hack" && nonuser_patcher
	    else
	      _patchname='proton-tkg-steamclient-swap-09db718.patch' && _patchmsg="Applied steamclient substitution hack" && nonuser_patcher
	    fi
	  fi
	fi

	echo -e "" >> "$_where"/last_build_config.log

	# Set mono version and hash for proton
	if [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_unfrog" != "true" ]; then
	  if [ "$_use_latest_mono" = "true" ]; then
	    mono_ver=$( ls "$_where"/wine-mono* | sed -e "s|.*wine-mono-||; s/-x86.msi//" )
	    mono_sum=$( echo $( sha256sum "$_where"/wine-mono* | cut -d " " -f 1 ) )
	    echo -e "Setting wine-mono version to ${mono_ver} with sha256 ${mono_sum}" >> "$_where"/last_build_config.log
	    sed -i "s|#define MONO_VERSION.*|#define MONO_VERSION \"${mono_ver}\"|g" "${srcdir}"/"${_winesrcdir}"/dlls/appwiz.cpl/addons.c
	    sed -i "s|#define MONO_SHA.*|#define MONO_SHA \"${mono_sum}\"|g" "${srcdir}"/"${_winesrcdir}"/dlls/appwiz.cpl/addons.c
	    sed -i "s|#define WINE_MONO_VERSION.*|#define WINE_MONO_VERSION \"${mono_ver}\"|g" "${srcdir}"/"${_winesrcdir}"/dlls/mscoree/mscoree_private.h
	  fi
	fi

	if [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_unfrog" != "true" ] && ! git merge-base --is-ancestor 74dc0c5df9c3094352caedda8ebe14ed2dfd615e HEAD || ([ "$_protonify" = "true" ] && git merge-base --is-ancestor 74dc0c5df9c3094352caedda8ebe14ed2dfd615e HEAD); then
	  if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor d8be85863fedf6982944d06ebd1ce5904cb3d4e1 HEAD ); then
	    if [ "$_use_staging" = "true" ]; then
	      if ! git merge-base --is-ancestor dedd5ccc88547529ffb1101045602aed59fa0170 HEAD; then
	        _patchname='proton-tkg-staging-rpc.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 1/3" && nonuser_patcher
	      fi
	      _patchname='proton-tkg-staging.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 2/3" && nonuser_patcher
	      if [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_unfrog" != "true" ]; then
	        if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor bf811fdcaf70883634691d2c7262c3d80fe32323 HEAD ); then
	          _patchname='proton-steam-bits.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 61e217c40a78011bbc37305a063b902582d49429 HEAD ); then
	          _patchname='proton-steam-bits-bf811fd.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 23d2d0c5a7421f3c71db430356fdaed7606fea00 HEAD ); then
	          _patchname='proton-steam-bits-61e217c.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 11daf1869078a60ed2588ff5a61a4d9b27985beb HEAD ); then
	          _patchname='proton-steam-bits-23d2d0c.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 8cd5c1bc37cb617a6e88698e289516cee8d2449f HEAD ); then
	          _patchname='proton-steam-bits-11daf18.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0a6f070f5ebb9b2013fa4ba24dd7d8c16399cf71 HEAD ); then
	          _patchname='proton-steam-bits-8cd5c1b.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 5b362f07f67db5f90ac355c62a1f3d73658c4346 HEAD ); then
	          _patchname='proton-steam-bits-0a6f070.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 636d398c7d60bc29f7eb0ff46dc66849fb5665e4 HEAD ); then
	          _patchname='proton-steam-bits-5b362f0.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 7caa127746fd880a263715879c9931fa67053fe0 HEAD ); then
	          _patchname='proton-steam-bits-636d398.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 7e51cc8308bd828d8d8a90aea35170c68d4b1bb4 HEAD ); then
	          _patchname='proton-steam-bits-7caa127.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	          _patchname='proton-steam-bits-7e51cc8.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor 9122bc1096f3231c5f6b8ffc0d7ad3e700f18af1 HEAD; then
	          _patchname='proton-steam-bits-de679af.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor 6eb05dab7c83893684b5e17e9e3a765835d77fcd HEAD; then
	          _patchname='proton-steam-bits-9122bc1.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor dc62d848284de0c3506279747f6ca504efb53a86 HEAD; then
	          _patchname='proton-steam-bits-6eb05da.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor f8fb43aaba499c6d0da05b0ee3a09c349a753cf8 HEAD; then
	          _patchname='proton-steam-bits-dc62d84.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        else
	          _patchname='proton-steam-bits-f8fb43a.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        fi
	        if [[ ! ${_staging_userargs[*]} =~ "ntdll-Syscall_Emulation" ]] && ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	          if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 805f2e9252de5b4de115335f803db4e753f66ff2 HEAD ); then
	            _patchname='proton-seccomp-envvar.patch' && _patchmsg="Add WINESECCOMP env var support" && nonuser_patcher
	          elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 595f2f9860adafed612737529745ad24c50acdb9 HEAD ); then
	            _patchname='proton-seccomp-envvar-805f2e9.patch' && _patchmsg="Add WINESECCOMP env var support" && nonuser_patcher
	          fi
	        fi
	      fi
	    else
	      if ! git merge-base --is-ancestor dedd5ccc88547529ffb1101045602aed59fa0170 HEAD; then
	        _patchname='proton-tkg-rpc.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 1/3" && nonuser_patcher
	      fi
	      _patchname='proton-tkg.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 2/3" && nonuser_patcher
	      if [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_unfrog" != "true" ]; then
	        if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor bf811fdcaf70883634691d2c7262c3d80fe32323 HEAD ); then
	          _patchname='proton-steam-bits.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 61e217c40a78011bbc37305a063b902582d49429 HEAD ); then
	          _patchname='proton-steam-bits-bf811fd.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 23d2d0c5a7421f3c71db430356fdaed7606fea00 HEAD ); then
	          _patchname='proton-steam-bits-61e217c.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 11daf1869078a60ed2588ff5a61a4d9b27985beb HEAD ); then
	          _patchname='proton-steam-bits-23d2d0c.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 8cd5c1bc37cb617a6e88698e289516cee8d2449f HEAD ); then
	          _patchname='proton-steam-bits-11daf18.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0a6f070f5ebb9b2013fa4ba24dd7d8c16399cf71 HEAD ); then
	          _patchname='proton-steam-bits-8cd5c1b.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 5b362f07f67db5f90ac355c62a1f3d73658c4346 HEAD ); then
	          _patchname='proton-steam-bits-0a6f070.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 636d398c7d60bc29f7eb0ff46dc66849fb5665e4 HEAD ); then
	          _patchname='proton-steam-bits-5b362f0.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 7caa127746fd880a263715879c9931fa67053fe0 HEAD ); then
	          _patchname='proton-steam-bits-636d398.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 7e51cc8308bd828d8d8a90aea35170c68d4b1bb4 HEAD ); then
	          _patchname='proton-steam-bits-7caa127.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	          _patchname='proton-steam-bits-7e51cc8.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor 9122bc1096f3231c5f6b8ffc0d7ad3e700f18af1 HEAD; then
	          _patchname='proton-steam-bits-de679af.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor 6eb05dab7c83893684b5e17e9e3a765835d77fcd HEAD; then
	          _patchname='proton-steam-bits-9122bc1.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor dc62d848284de0c3506279747f6ca504efb53a86 HEAD; then
	          _patchname='proton-steam-bits-6eb05da.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor f8fb43aaba499c6d0da05b0ee3a09c349a753cf8 HEAD; then
	          _patchname='proton-steam-bits-dc62d84.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        else
	          _patchname='proton-steam-bits-f8fb43a.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        fi
	      fi
	    fi
	  else
	    if git merge-base --is-ancestor e7b0b35d57d3567d6b6891beaf3241179a926ad6 HEAD; then
	      _lastcommit="d8be858"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor b7fafabc77b58fb33a5a543d423232f18f9d5f05 HEAD; then
	      _lastcommit="e7b0b35"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 72449b76e8e40f1690762545fd2c0021647da140 HEAD; then
	      _lastcommit="b7fafab"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 6ba7773121fd3b65e48ba65b49e742ab9b061210 HEAD; then
	      _lastcommit="72449b7"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 7b17d7081512db52ef852705445762ac4016c29f HEAD; then
	      _lastcommit="6ba7773"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor d94d1a8b263a020575bf8dd76509d9e603434095 HEAD; then
	      _lastcommit="7b17d70"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 847db3c1d3f5444808814cbea8f2920b16a96fcb HEAD; then
	      _lastcommit="d94d1a8"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor d127a14a7f1941539753f029fb52f407514b1106 HEAD; then
	      _lastcommit="847db3c"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor d327527cec22c1123781e6c5a637032a31698b91 HEAD; then
	      _lastcommit="d127a14"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor e58405000c6037d9d281ec06a87bf72c5fc79866 HEAD; then
	      _lastcommit="d327527"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 20fff538c49c87abffd583f6b63371592ebdd835 HEAD; then
	      _lastcommit="e584050"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 5c009c17b3a212c3f5b0034c465077c0c593daae HEAD; then
	      _lastcommit="20fff53"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 0986c8a35fdf9e1070390e0a424042f8396b6932 HEAD; then
	      _lastcommit="5c009c1"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 21f5597de417575d476a00b567d972a89903b4b6 HEAD; then
	      _lastcommit="0986c8a"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 8c0ced87bcec8bdc505bf844cc9247106ebd8c36 HEAD; then
	      _lastcommit="21f5597"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor ec9f3119306e34f5a8bd3bfeb233eed740c1c6ae HEAD; then
	      _lastcommit="8c0ced8"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 5d82baf9747b7b133cad3be77c0cc9e24cc09582 HEAD; then
	      _lastcommit="ec9f311"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 02e3327f0687559486739f7da7b602c2baae070a HEAD; then
	      _lastcommit="5d82baf"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 96abde9eac97dc0fa5ff6ec8176e51cc3673fb44 HEAD; then
	      _lastcommit="02e3327"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 72c562ce9c481e73a01f50e17b624095aab11bdc HEAD; then
	      _lastcommit="96abde9"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 11daf1869078a60ed2588ff5a61a4d9b27985beb HEAD; then
	      _lastcommit="72c562c"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 7ef35b33936682c01f1c825b7d1b07567a691c12 HEAD; then
	      _lastcommit="11daf18"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 90024e492dcefd204c6c953a804c0d51544db5b2 HEAD; then
	      _lastcommit="7ef35b3"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor a24bdfc2c69c5648cbb3df762149b2647e209a09 HEAD; then
	      _lastcommit="90024e4"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 2cb4bdb10abcfd751d4d1b2ca7780c778166608a HEAD; then
	      _lastcommit="a24bdfc"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor e51ae86937c547124c906fb1d5db7a142af60686 HEAD; then
	      _lastcommit="2cb4bdb"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 65cff869513f8f66655b602ab2bc62e1c3b69c51 HEAD; then
	      _lastcommit="e51ae86"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 8abcae547501809d1cbf01b14669707c0bd66714 HEAD; then
	      _lastcommit="65cff86"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 10dde32dc6c530d755f68a6edfb50d21c6edd2a8 HEAD; then
	      _lastcommit="8abcae5"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 26ee9134d5d75ee515ccf06987cd024b64e498aa HEAD; then
	      _lastcommit="10dde32"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 50798b1320b24e7c74d350853a895b16881c376d HEAD; then
	      _lastcommit="26ee913"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 0027827290f4a411389e402eb2e1766d94e5e0c1 HEAD; then
	      _lastcommit="50798b1"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor c6d85fc2178094840a5ea2cd4823c7b68e48e473 HEAD; then
	      _lastcommit="0027827"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor d4bb0c4639aea2e8df80e577bd20b7f51c033e33 HEAD; then
	      _lastcommit="c6d85fc"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 6f158754435f403864052e595ab627dadac2666f HEAD; then
	      _lastcommit="d4bb0c4"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 251262a44a8f8403fd963e7bb510da778944af1b HEAD; then
	      _lastcommit="6f15875"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 447924a6d68f7919bd451661314a52aa99cab709 HEAD; then
	      _lastcommit="251262a"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 60f11d2929629f0da257b810936f0239ad895596 HEAD; then
	      _lastcommit="447924a"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 1f3064c5d5ac851c6fdfb85bc8ff5ea046f32acc HEAD; then
	      _lastcommit="60f11d2"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 89698cfae4d9aefd3f77c2982e64f7b98e00edf1 HEAD; then
	      _lastcommit="1f3064c"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD; then
	      _lastcommit="89698cf"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 1ec8bf9b739f1528b742169670eac2350b33a7d4 HEAD; then
	      _lastcommit="de679af"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 7d67c412ead12a9db963ff74977f4a63f5d02aa9 HEAD; then
	      _lastcommit="1ec8bf9"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor d17b118f030407a973a4aaaab58774449a6235cc HEAD; then
	      _lastcommit="7d67c41"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor d806203850c9666ff32637f5215fbb21a0f2bc9c HEAD; then
	      _lastcommit="d17b118"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor d93137e2e07e0fea56e0c5148c27b1c7e9cb5a65 HEAD; then
	      _lastcommit="d806203"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 8898a6951988c95db3e92146b948a3b2aed08fd2 HEAD; then
	      _lastcommit="d93137e"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 0556d9e6f1c0951e6e4026efe3b176407b82fc7b HEAD; then
	      _lastcommit="8898a69"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor a302ab44acaf72ecc9b0307c82a7d11f759e6a72 HEAD; then
	      _lastcommit="0556d9e"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 2633a5c1ae542f08f127ba737fa59fb03ed6180b HEAD; then
	      _lastcommit="a302ab4"
	      _rpc="1"
	      _stmbits="1"
	    elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor d33cdb84fd8fed24e3a9ce89954ad43213b86426 HEAD ); then
	      _lastcommit="2633a5c"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor dedd5ccc88547529ffb1101045602aed59fa0170 HEAD; then
	      _lastcommit="d33cdb8"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 7f9eb22af8c3c8f9a0d8e07b0e6d8ee89feacd9e HEAD; then
	      _lastcommit="dedd5cc"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor bbf2836a85046bf9af2dca3b3158250d79302324 HEAD; then
	      _lastcommit="7f9eb22"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor b87256cd1db21a59484248a193b6ad12ca2853ca HEAD; then
	      _lastcommit="bbf2836"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 120505ed6b590daea11486a512dd563600d0329f HEAD; then
	      _lastcommit="b87256c"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 9d38c4864c4800313812feef2c3bc6ca6551ce57 HEAD; then
	      _lastcommit="120505e"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 14df0183b0b43049d0f645f72f435309cb6836a4 HEAD; then
	      _lastcommit="9d38c48"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 56a6bc87acbbbee74fb6cd8e77ae61828e274c2d HEAD; then
	      _lastcommit="14df018"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 50aeb5e777d9a8836f5530755afab10e042c623f HEAD; then
	      _lastcommit="56a6bc8"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 74dc0c5df9c3094352caedda8ebe14ed2dfd615e HEAD; then
	      _lastcommit="50aeb5e"
	      _rpc="1"
	      _stmbits="1"
	    elif git merge-base --is-ancestor 2aad95254c19df21fc0f7c4413ca3874c8d87997 HEAD; then
	      _lastcommit="74dc0c5"
	      _rpc="1"
	    elif git merge-base --is-ancestor 8000b5415d2c249176bda3d8b49f8fc9978e1623 HEAD; then
	      _lastcommit="2aad952"
	      _rpc="1"
	    elif git merge-base --is-ancestor 51ffea5a3940bdc74b44b9303c4574dfb156efc0 HEAD; then
	      _lastcommit="8000b54"
	      _rpc="1"
	    elif git merge-base --is-ancestor 477ff7e034e882cf0dc24aa0b459ec957608a1c3 HEAD; then
	      _lastcommit="51ffea5"
	      _rpc="1"
	    elif git merge-base --is-ancestor aa827393311987319998a5dc1860e4696d495114 HEAD; then
	      _lastcommit="477ff7e"
	      _rpc="1"
	    elif git merge-base --is-ancestor b7db0b52cee65a008f503ce727befcad3ba8d28a HEAD; then
	      _lastcommit="aa82739"
	      _rpc="1"
	    elif git merge-base --is-ancestor 6d7828e8df68178ca662bc618f7598254afcfbe1 HEAD; then
	      _lastcommit="b7db0b5"
	      _rpc="1"
	    elif git merge-base --is-ancestor 8d25965e12717b266f2fc74bb10d915234d16772 HEAD; then
	      _lastcommit="6d7828e"
	      _rpc="1"
	    elif git merge-base --is-ancestor 619bd16e7a7486ca72cde1df01791629efb61341 HEAD; then
	      _lastcommit="8d25965"
	      _rpc="1"
	    elif git merge-base --is-ancestor 940c3b4896a75b65351d4c7d610f1071d0c9d0be HEAD; then
	      _lastcommit="619bd16"
	      _rpc="1"
	    elif git merge-base --is-ancestor 0bebbbaa51c7647389ef9ac886169f6037356460 HEAD; then
	      _lastcommit="940c3b4"
	    elif git merge-base --is-ancestor 05d00276c627753487c571c30fddfc56c02ad37e HEAD; then
	      _lastcommit="0bebbba"
	    elif git merge-base --is-ancestor 09f588ee6909369b541398dd392d3ff77231e6a6 HEAD; then
	      _lastcommit="05d0027"
	    elif git merge-base --is-ancestor 0116660dd80b38da8201e2156adade67fc2ae823 HEAD; then
	      _lastcommit="09f588e"
	    elif git merge-base --is-ancestor eafb4aff5a2c322f4f156fdfada5743834996be4 HEAD; then
	      _lastcommit="0116660"
	    else
	      _lastcommit="eafb4af"
        fi
	    if [ "$_use_staging" = "true" ]; then
	      if ! git merge-base --is-ancestor dedd5ccc88547529ffb1101045602aed59fa0170 HEAD && [ "$_rpc" = "1" ]; then
	        _patchname='proton-tkg-staging-rpc.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 1/2" && nonuser_patcher
	      fi
	      _patchname="proton-tkg-staging-$_lastcommit.patch" && _patchmsg="Using Steam-specific Proton-tkg patches (staging-$_lastcommit) 2/2" && nonuser_patcher
	      if [ "$_stmbits" = "1" ] && [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_unfrog" != "true" ]; then
	        if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor bf811fdcaf70883634691d2c7262c3d80fe32323 HEAD ); then
	          _patchname='proton-steam-bits.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 61e217c40a78011bbc37305a063b902582d49429 HEAD ); then
	          _patchname='proton-steam-bits-bf811fd.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 23d2d0c5a7421f3c71db430356fdaed7606fea00 HEAD ); then
	          _patchname='proton-steam-bits-61e217c.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 11daf1869078a60ed2588ff5a61a4d9b27985beb HEAD ); then
	          _patchname='proton-steam-bits-23d2d0c.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 8cd5c1bc37cb617a6e88698e289516cee8d2449f HEAD ); then
	          _patchname='proton-steam-bits-11daf18.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0a6f070f5ebb9b2013fa4ba24dd7d8c16399cf71 HEAD ); then
	          _patchname='proton-steam-bits-8cd5c1b.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 5b362f07f67db5f90ac355c62a1f3d73658c4346 HEAD ); then
	          _patchname='proton-steam-bits-0a6f070.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 636d398c7d60bc29f7eb0ff46dc66849fb5665e4 HEAD ); then
	          _patchname='proton-steam-bits-5b362f0.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 7caa127746fd880a263715879c9931fa67053fe0 HEAD ); then
	          _patchname='proton-steam-bits-636d398.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 7e51cc8308bd828d8d8a90aea35170c68d4b1bb4 HEAD ); then
	          _patchname='proton-steam-bits-7caa127.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	          _patchname='proton-steam-bits-7e51cc8.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor 9122bc1096f3231c5f6b8ffc0d7ad3e700f18af1 HEAD; then
	          _patchname='proton-steam-bits-de679af.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor 6eb05dab7c83893684b5e17e9e3a765835d77fcd HEAD; then
	          _patchname='proton-steam-bits-9122bc1.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor dc62d848284de0c3506279747f6ca504efb53a86 HEAD; then
	          _patchname='proton-steam-bits-6eb05da.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor f8fb43aaba499c6d0da05b0ee3a09c349a753cf8 HEAD; then
	          _patchname='proton-steam-bits-dc62d84.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        else
	          _patchname='proton-steam-bits-f8fb43a.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging) 3/3" && nonuser_patcher
	        fi
	        if [[ ! ${_staging_userargs[*]} =~ "ntdll-Syscall_Emulation" ]] && ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	          if ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 805f2e9252de5b4de115335f803db4e753f66ff2 HEAD ); then
	            _patchname='proton-seccomp-envvar.patch' && _patchmsg="Add WINESECCOMP env var support" && nonuser_patcher
	          elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 595f2f9860adafed612737529745ad24c50acdb9 HEAD ); then
	            _patchname='proton-seccomp-envvar-805f2e9.patch' && _patchmsg="Add WINESECCOMP env var support" && nonuser_patcher
	          fi
	        fi
	      fi
	    else
	      if ! git merge-base --is-ancestor dedd5ccc88547529ffb1101045602aed59fa0170 HEAD && [ "$_rpc" = "1" ]; then
	        _patchname='proton-tkg-rpc.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 1/2" && nonuser_patcher
	      fi
	      _patchname="proton-tkg-$_lastcommit.patch" && _patchmsg="Using Steam-specific Proton-tkg patches ($_lastcommit) 2/2" && nonuser_patcher
	      if [ "$_stmbits" = "1" ] && [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_unfrog" != "true" ]; then
	        if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor bf811fdcaf70883634691d2c7262c3d80fe32323 HEAD ); then
	          _patchname='proton-steam-bits.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 61e217c40a78011bbc37305a063b902582d49429 HEAD ); then
	          _patchname='proton-steam-bits-bf811fd.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 23d2d0c5a7421f3c71db430356fdaed7606fea00 HEAD ); then
	          _patchname='proton-steam-bits-61e217c.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 11daf1869078a60ed2588ff5a61a4d9b27985beb HEAD ); then
	          _patchname='proton-steam-bits-23d2d0c.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 8cd5c1bc37cb617a6e88698e289516cee8d2449f HEAD ); then
	          _patchname='proton-steam-bits-11daf18.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0a6f070f5ebb9b2013fa4ba24dd7d8c16399cf71 HEAD ); then
	          _patchname='proton-steam-bits-8cd5c1b.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 5b362f07f67db5f90ac355c62a1f3d73658c4346 HEAD ); then
	          _patchname='proton-steam-bits-0a6f070.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 636d398c7d60bc29f7eb0ff46dc66849fb5665e4 HEAD ); then
	          _patchname='proton-steam-bits-5b362f0.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 7caa127746fd880a263715879c9931fa67053fe0 HEAD ); then
	          _patchname='proton-steam-bits-636d398.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 7e51cc8308bd828d8d8a90aea35170c68d4b1bb4 HEAD ); then
	          _patchname='proton-steam-bits-7caa127.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	          _patchname='proton-steam-bits-7e51cc8.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor 9122bc1096f3231c5f6b8ffc0d7ad3e700f18af1 HEAD; then
	          _patchname='proton-steam-bits-de679af.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor 6eb05dab7c83893684b5e17e9e3a765835d77fcd HEAD; then
	          _patchname='proton-steam-bits-9122bc1.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor dc62d848284de0c3506279747f6ca504efb53a86 HEAD; then
	          _patchname='proton-steam-bits-6eb05da.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        elif git merge-base --is-ancestor f8fb43aaba499c6d0da05b0ee3a09c349a753cf8 HEAD; then
	          _patchname='proton-steam-bits-dc62d84.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        else
	          _patchname='proton-steam-bits-f8fb43a.patch' && _patchmsg="Using Steam-specific Proton-tkg patches 3/3" && nonuser_patcher
	        fi
	      fi
	    fi
	  fi
	  if [ "$_staging_pulse_disable" != "true" ] && [ "$_use_staging" = "true" ] && ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor d3673fcb034348b708a5d8b8c65a746faaeec19d HEAD ); then
	    if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 8c0ced87bcec8bdc505bf844cc9247106ebd8c36 HEAD ); then
	      _patchname='proton-pa-staging.patch' && _patchmsg="Enable Proton's PA additions" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor fa6d22b976214ff4dfb32b431500b4cd1f7610a0 HEAD ); then
	      _patchname='proton-pa-staging-8c0ced8.patch' && _patchmsg="Enable Proton's PA additions" && nonuser_patcher
	    else
	      _patchname='proton-pa-staging-fa6d22b.patch' && _patchmsg="Enable Proton's PA additions" && nonuser_patcher
	    fi
	  fi
	  if [ "$_EXTERNAL_INSTALL" = "proton" ] && ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 9ca95e32651d6a50dc787af4dc53fb907f1c4e2b HEAD ); then
	    if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 1aa359a100bae859b278007e8bf90673eebd7db0 HEAD ); then
	      if [ "$_use_staging" = "false" ]; then
	        _patchname='proton-gstreamer.patch' && _patchmsg="Enable Proton's gstreamer additions" && nonuser_patcher
	      elif ! grep -Fxq 'Disabled: True' "${srcdir}/${_stgsrcdir}/patches/mfplat-streaming-support/definition"; then
	        _patchname='proton-gstreamer-staging.patch' && _patchmsg="Enable Proton's gstreamer additions" && nonuser_patcher
	      fi
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor aeabe991ff8ae69ee9959b908851f8b1148f7cf4 HEAD ); then
	      if [ "$_use_staging" = "false" ]; then
	        _patchname='proton-gstreamer-1aa359a.patch' && _patchmsg="Enable Proton's gstreamer additions" && nonuser_patcher
	      elif ! grep -Fxq 'Disabled: True' "${srcdir}/${_stgsrcdir}/patches/mfplat-streaming-support/definition"; then
	        _patchname='proton-gstreamer-staging.patch' && _patchmsg="Enable Proton's gstreamer additions" && nonuser_patcher
	      fi
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor e36e384cb4d96fd47763332f93c2b213f6556287 HEAD ); then
	      if [ "$_use_staging" = "false" ]; then
	        _patchname='proton-gstreamer-aeabe99.patch' && _patchmsg="Enable Proton's gstreamer additions" && nonuser_patcher
	      elif ! grep -Fxq 'Disabled: True' "${srcdir}/${_stgsrcdir}/patches/mfplat-streaming-support/definition"; then
	        _patchname='proton-gstreamer-staging-aeabe99.patch' && _patchmsg="Enable Proton's gstreamer additions" && nonuser_patcher
	      fi
	    elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 9bf50b7e1f73b3b853eef71e9e2ff1739d21cbf4 HEAD ); then
	      if [ "$_use_staging" = "false" ]; then
	        _patchname='proton-gstreamer-e36e384.patch' && _patchmsg="Enable Proton's gstreamer additions" && nonuser_patcher
	      elif ! grep -Fxq 'Disabled: True' "${srcdir}/${_stgsrcdir}/patches/mfplat-streaming-support/definition"; then
	        _patchname='proton-gstreamer-staging-e36e384.patch' && _patchmsg="Enable Proton's gstreamer additions" && nonuser_patcher
	      fi
	    fi
	  fi
	  # Legacy wine.gaming.input patchset (Death Stranding)
	  if git merge-base --is-ancestor 1ec8bf9b739f1528b742169670eac2350b33a7d4 HEAD; then
	    if ( [ "$_use_staging" = "false" ] && ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor 5604d34439aa805fb11a5a6ba70ad87a31f93afa HEAD ) ) || ( [ "$_use_staging" = "true" ] && ( cd "${srcdir}"/"${_stgsrcdir}" && ! git merge-base --is-ancestor c4b73e1752354f1759cc8b1cad39e1931dd85a51 HEAD ) ); then
	      _patchname='proton-windows.gaming.input.patch' && _patchmsg="Enable Proton's legacy wine.gaming.input patchset for Death Stranding" && nonuser_patcher
	    fi
	  fi
	fi

	# Proton RDR2 fixes from Paul Gofman - Bound to the "Protonify the staging syscall emu" hotfix
	# The legacy patch is found in proton meta patchsets, and was moved here for more flexibility following the recent ntdll changes
	if [ "$_use_staging" = "true" ] && [ -e "$_where"/rdr2.patch ]; then
	  _patchname='rdr2.patch' && _patchmsg="Enable Proton's RDR2 fixes from Paul Gofman" && nonuser_patcher
	fi

	# Proton Quake Champions fixes from Paul Gofman
	if [ "$_quake_champions_fix" = "true" ] && [ "$_protonify" = "true" ] && [ "$_use_staging" = "true" ]; then
	  if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 3513a176fd325492e5b5e498e4eebf3f820f8cc6 HEAD ); then
	    _patchname='quake_champions_fix.patch' && _patchmsg="Enable Proton's Quake Champions fixes from Paul Gofman" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 66c0fdc1590e00ce471a6c55f4d97ededd1f5aae HEAD ); then
	    _patchname='quake_champions_fix-3513a17.patch' && _patchmsg="Enable Proton's Quake Champions fixes from Paul Gofman" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 588d91aecf2bf8ac7e9ae1de44ddc01caae52109 HEAD ); then
	    _patchname='quake_champions_fix-66c0fdc.patch' && _patchmsg="Enable Proton's Quake Champions fixes from Paul Gofman" && nonuser_patcher
	  fi
	fi

	# Proton CPU topology override - depends on protonify and fsync
	if [ "$_use_esync" = "true" ] && [ "$_use_fsync" = "true" ] && [ "$_protonify" = "true" ] && ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 6f158754435f403864052e595ab627dadac2666f HEAD ); then
	  if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 588d91aecf2bf8ac7e9ae1de44ddc01caae52109 HEAD ); then
	    _patchname='proton-cpu-topology-overrides.patch' && _patchmsg="Enable Proton's CPU topology override support" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor be8bd6f498dadbafe068c1fbb02adcbadf0b1b56 HEAD ); then
	    _patchname='proton-cpu-topology-overrides-588d91a.patch' && _patchmsg="Enable Proton's CPU topology override support" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 5864bc88de0e0a3b1094c2bb0c16ba9a5d39ce65 HEAD ); then
	    _patchname='proton-cpu-topology-overrides-be8bd6f.patch' && _patchmsg="Enable Proton's CPU topology override support" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor c88b2ed3c04fdde86fc1fca670ae862056e614da HEAD ); then
	    _patchname='proton-cpu-topology-overrides-5864bc8.patch' && _patchmsg="Enable Proton's CPU topology override support" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor a3c92a02cc7014cfdb1f90f1d070037868067097 HEAD ); then
	    _patchname='proton-cpu-topology-overrides-c88b2ed.patch' && _patchmsg="Enable Proton's CPU topology override support" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 44699c324f20690f9d6836919534ca1b5bcc3efe HEAD ); then
	    _patchname='proton-cpu-topology-overrides-a3c92a0.patch' && _patchmsg="Enable Proton's CPU topology override support" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 7999af82448c340b28e3d6e412463c5cdcc6cea6 HEAD ); then
	    _patchname='proton-cpu-topology-overrides-44699c3.patch' && _patchmsg="Enable Proton's CPU topology override support" && nonuser_patcher
	  else
	    _patchname='proton-cpu-topology-overrides-7999af8.patch' && _patchmsg="Enable Proton's CPU topology override support" && nonuser_patcher
	  fi
	fi

	# SDL Joystick support - from Proton
	if [ "$_sdl_joy_support" = "true" ] && [ "$_use_staging" = "true" ]; then
	  if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 43f0c8096b2d81052a30d8542372adc46dab8292 HEAD ); then
	    _patchname='proton-sdl-joy.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 914633723383f321303d78eb62cb19e8a6fb7bb4 HEAD ); then
	    _patchname='proton-sdl-joy-43f0c80.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 01d3527065e6f29997eb0ec88e36aeeecbf8ff76 HEAD ); then
	    _patchname='proton-sdl-joy-9146337.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 828b9b8cc49fe24a306235c056a38c7ae079560f HEAD ); then
	    _patchname='proton-sdl-joy-01d3527.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 2bd3c9703d3385820c1829a78ef71e7701d3a77a HEAD ); then
	    _patchname='proton-sdl-joy-828b9b8.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	  elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor a17367291104e46c573b7213ee94a0f537563ace HEAD ); then
	    _patchname='proton-sdl-joy-5fe1031.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	  elif [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_unfrog" != "true" ]; then
	    if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor f34b735eba04ee1deeba1e9bbf151956a23b81f2 HEAD ) && [ "$_use_staging" = "true" ]; then
	      _patchname='proton-sdl-joy-a173672.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 27f40156baa7f1e09c6e420f6c278606557a505a HEAD ) && [ "$_use_staging" = "true" ]; then
	      _patchname='proton-sdl-joy-f34b735.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 661df7b889bb973721d09a316d87d200a31233fe HEAD ) && [ "$_use_staging" = "true" ]; then
	      _patchname='proton-sdl-joy-27f4015.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 626870abe2e800cc9407d05d5c00500a4ad97b3a HEAD ) && [ "$_use_staging" = "true" ]; then
	      _patchname='proton-sdl-joy-661df7b.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor b71cea76ed24ca940783e01da54917eefa0bb36b HEAD ) && [ "$_use_staging" = "true" ]; then
	      _patchname='proton-sdl-joy-626870a.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor e4fbae832c868e9fcf5a91c58255fe3f4ea1cb30 HEAD ) && [ "$_use_staging" = "true" ]; then
	      _patchname='proton-sdl-joy-b71cea7.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 6373792eec0f122295723cae77b0115e6c96c3e4 HEAD ) && [ "$_use_staging" = "true" ]; then
	      _patchname='proton-sdl-joy-e4fbae8.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	    elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	      _patchname='proton-sdl-joy-6373792.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	    elif git merge-base --is-ancestor 306c40e67319cae8e4c448ec8fc8d3996f87943f HEAD; then
	      _patchname='proton-sdl-joy-0c249e6.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	    elif git merge-base --is-ancestor b87256cd1db21a59484248a193b6ad12ca2853ca HEAD; then
	      _patchname='proton-sdl-joy-306c40e.patch' && _patchmsg="Enable SDL Joystick support (from Proton) (<306c40e)" && nonuser_patcher
	    else
	      _patchname='proton-sdl-joy-b87256c.patch' && _patchmsg="Enable SDL Joystick support (from Proton) (<b87256c)" && nonuser_patcher
	    fi
	    if ( git merge-base --is-ancestor 1daeef73325e9d35073231baf874600050126c7f HEAD && ! git merge-base --is-ancestor 6373792eec0f122295723cae77b0115e6c96c3e4 HEAD ); then
	      _patchname='proton-sdl-joy-2.patch' && _patchmsg="Enable SDL Joystick support additions (from Proton)" && nonuser_patcher
	    fi
	    # Gamepad additions - from Proton
	    if ( [ "$_gamepad_additions" = "true" ] && [ "$_use_staging" = "true" ] && ! git merge-base --is-ancestor 6373792eec0f122295723cae77b0115e6c96c3e4 HEAD ); then
	      if git merge-base --is-ancestor 6cb3d0fb3778f660546e581787b1734e2b1d2955 HEAD; then
	        _patchname='proton-gamepad-additions.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      elif git merge-base --is-ancestor c074966b9d75d9519e8640e87725ad439f4ffa0c HEAD; then
	        _patchname='proton-gamepad-additions-6cb3d0f.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      elif git merge-base --is-ancestor aa482426dc4d6f291e6d1dd75be4701636cab31d HEAD; then
	        _patchname='proton-gamepad-additions-c074966.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      elif git merge-base --is-ancestor 8db70e92a899fea6711c4f4fa3fa45adf1574fe8 HEAD; then
	        _patchname='proton-gamepad-additions-aa48242.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor fcfeaf092cf9e8060223744f507395946554fe09 HEAD ); then
	        _patchname='proton-gamepad-additions-8db70e9.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      elif git merge-base --is-ancestor d2d3959d3d29b3da334b53283b34cafde653b3e8 HEAD; then
	        _patchname='proton-gamepad-additions-fcfeaf0.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      elif ( cd "${srcdir}"/"${_stgsrcdir}" && git merge-base --is-ancestor 4413770af102ed80f9c5c19a9148ab32d3dc1a0f HEAD ); then
	        _patchname='proton-gamepad-additions-d2d3959.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      elif git merge-base --is-ancestor 9c6ea019358eadcf86159872e2890ffc94960965 HEAD; then
	        _patchname='proton-gamepad-additions-4413770.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      elif git merge-base --is-ancestor f8a04c7f2e2c77eef663c5bb2109e3dbd51b22e0 HEAD; then
	        _patchname='proton-gamepad-additions-9c6ea01.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      elif git merge-base --is-ancestor 3d011fcdffe39ae856cbb0915938fe158b60742a HEAD; then
	        _patchname='proton-gamepad-additions-f8a04c7.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      elif git merge-base --is-ancestor 50b9456e878f57d8c850282d77e74534c57a181e HEAD; then
	        _patchname='proton-gamepad-additions-3d011fc.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      elif git merge-base --is-ancestor 6a610a325809d47f48bc72f3a757e1a62b193ea8 HEAD; then
	        _patchname='proton-gamepad-additions-50b9456.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      fi
	    elif ( [ "$_gamepad_additions" = "true" ] && [ "$_use_staging" = "true" ] && git merge-base --is-ancestor 6373792eec0f122295723cae77b0115e6c96c3e4 HEAD && ! git merge-base --is-ancestor b71cea76ed24ca940783e01da54917eefa0bb36b HEAD ); then
	      _patchname='proton-gamepad-additions-exp.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton exp)" && nonuser_patcher
	    fi
	  fi
	fi

	if [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_unfrog" != "true" ]; then
	  #if git merge-base --is-ancestor 0ffb1535517301d28c7c004eac639a9a0cc26c00 HEAD; then
	  #  _patchname='proton-restore-unicode.patch' && _patchmsg="Restore installing wine/unicode.h to please Proton" && nonuser_patcher
	  #fi
	  if [ "$_wined3d_additions" = "true" ] && [ "$_use_staging" = "false" ]; then
	    _patchname='proton-wined3d-additions.patch' && _patchmsg="Enable Proton non-vr-related wined3d additions" && nonuser_patcher
	  fi
	  if [ "$_steamvr_support" = "true" ]; then
	    if git merge-base --is-ancestor 12d33d21d33788fd46898ea42e9592d33b6e7c8e HEAD; then # 6.12
	      _patchname='proton-vr.patch' && _patchmsg="Enable Proton vr-related wined3d additions" && nonuser_patcher
	    elif git merge-base --is-ancestor bff6bc6a79ffc3a915219a6dfe64c9bcabaaeceb HEAD && [ "$_proton_fs_hack" = "true" ]; then
	      _patchname='proton-vr-12d33d2.patch' && _patchmsg="Enable Proton vr-related wined3d additions" && nonuser_patcher
	    elif git merge-base --is-ancestor e447e86ae2fbfbd9dee1b488e38a653aaea5447e HEAD && [ "$_proton_fs_hack" = "true" ]; then
	      _patchname='proton-vr-bff6bc6.patch' && _patchmsg="Enable Proton vr-related wined3d additions" && nonuser_patcher
	    elif git merge-base --is-ancestor a6d74b0545afcbf05d53fcbc9641ecc36c3be95c HEAD && [ "$_proton_fs_hack" = "true" ]; then
	      _patchname='proton-vr-e447e86.patch' && _patchmsg="Enable Proton vr-related wined3d additions" && nonuser_patcher
	    elif git merge-base --is-ancestor c736321633c6a247b406be50b1780ca0439ef8b0 HEAD && [ "$_proton_fs_hack" = "true" ]; then
	      _patchname='proton-vr-a6d74b.patch' && _patchmsg="Enable Proton vr-related wined3d additions (<a6d74b)" && nonuser_patcher
	    elif [ "$_proton_fs_hack" = "true" ]; then
	      _patchname='proton-vr-c736321.patch' && _patchmsg="Enable Proton vr-related wined3d additions (<c736321)" && nonuser_patcher
	    fi
	  fi
	fi

	# Proton fs hack additions
	if [ "$_unfrog" != "true" ]; then
	  if ! git merge-base --is-ancestor 0f972e2247932f255f131792724e4796b4b2b87a HEAD; then
	    if git merge-base --is-ancestor 1e074c39f635c585595e9f3ece99aa290a7f9cf8 HEAD && [ "$_proton_fs_hack" = "true" ]; then
	      _patchname='proton-vk-bits-4.5.patch' && _patchmsg="Enable Proton vulkan bits for 4.5+" && nonuser_patcher
	    elif git merge-base --is-ancestor 408a5a86ec30e293bf9e6eec4890d552073a82e8 HEAD && [ "$_proton_fs_hack" = "true" ]; then
	      _patchname='proton-vk-bits-4.5-1e074c3.patch' && _patchmsg="Enable Proton vulkan bits for 4.5+" && nonuser_patcher
	    elif git merge-base --is-ancestor 3e4189e3ada939ff3873c6d76b17fb4b858330a8 HEAD && [ "$_proton_fs_hack" = "true" ]; then
	      _patchname='proton-vk-bits-4.5-408a5a8.patch' && _patchmsg="Enable Proton vulkan bits for 4.5+" && nonuser_patcher
	    fi
	    if git merge-base --is-ancestor 458e0ad5133c9a449e22688a89183f3a6ab286e4 HEAD && [ "$_proton_fs_hack" = "true" ]; then
	      _patchname='proton_fs_hack_integer_scaling.patch' && _patchmsg="Enable Proton fs hack integer scaling" && nonuser_patcher
	    fi
	  fi

	  if [ "$_update_winevulkan" = "true" ] && git merge-base --is-ancestor 7e736b5903d3d078bbf7bb6a509536a942f6b9a0 HEAD && ( ! git merge-base --is-ancestor 0f972e2247932f255f131792724e4796b4b2b87a HEAD || git merge-base --is-ancestor 21e002aa7e7f85d92d1efeaeb7a9545eb16b96ad HEAD && [ "$_proton_fs_hack" = "true" ] ); then
	    if git merge-base --is-ancestor 221995a6838da5be2217735c3b1e1b1cd8f01e9f HEAD; then
	      if [ "$_proton_fs_hack" = "true" ]; then
	        _patchname='proton-winevulkan.patch' && _patchmsg="Using Proton winevulkan patches" && nonuser_patcher
	      else
	        _patchname='proton-winevulkan-nofshack.patch' && _patchmsg="Using Proton winevulkan patches (nofshack)" && nonuser_patcher
	      fi
	    else
	      if git merge-base --is-ancestor 8285f616030f27877922ff414530d4f909306ace HEAD; then
	        _lastcommit="221995a"
	      elif git merge-base --is-ancestor 9561af9a7d8d77e2f98341e278c842226cae47ed HEAD; then
	        _lastcommit="8285f61"
	      elif git merge-base --is-ancestor 88da78ef428317ff8c258277511abebf1a75e186 HEAD; then
	        _lastcommit="9561af9"
	      elif git merge-base --is-ancestor c681a0732fc3c6466b228417bb5e0d518d26b819 HEAD; then
	        _lastcommit="88da78e"
	      elif git merge-base --is-ancestor eb9f3dd3ad07aae3c9588bcff376ed2a7a8ef8d2 HEAD; then
	        _lastcommit="c681a07"
	      elif git merge-base --is-ancestor 7d8c50e4371f2fc5300b90b323210c922d80d4e9 HEAD; then
	        _lastcommit="eb9f3dd"
	      elif git merge-base --is-ancestor fc893489fe89c9fbd22f0cbe1c4327c64f05e0dc HEAD; then
	        _lastcommit="7d8c50e"
	      elif git merge-base --is-ancestor bff6bc6a79ffc3a915219a6dfe64c9bcabaaeceb HEAD; then
	        _lastcommit="fc89348"
	      elif git merge-base --is-ancestor 1e074c39f635c585595e9f3ece99aa290a7f9cf8 HEAD; then
	        _lastcommit="bff6bc6"
	      elif git merge-base --is-ancestor 8bd62231c3ab222c07063cb340e26c3c76ff4229 HEAD; then
	        _lastcommit="1e074c3"
	      elif git merge-base --is-ancestor 380b7f28253c048d04c1fbd0cfbc7e804bb1b0e1 HEAD; then
	        _lastcommit="8bd6223"
	      elif git merge-base --is-ancestor 408a5a86ec30e293bf9e6eec4890d552073a82e8 HEAD; then
	        _lastcommit="380b7f2"
	      elif git merge-base --is-ancestor d2f552d1508dbabb595eae23db9e5c157eaf9b41 HEAD; then
	        _lastcommit="408a5a8"
	      elif git merge-base --is-ancestor 594814c00ab059d9686ed836b1865f8a94859c8a HEAD; then
	        _lastcommit="d2f552d"
	      elif git merge-base --is-ancestor 086c686e817a596e35c41dd5b37f3c28587af9d5 HEAD; then
	        _lastcommit="594814c"
	      elif git merge-base --is-ancestor bdeae71bc129ac83c44753672d110b06a480c93c HEAD; then
	        _lastcommit="086c686"
	      elif git merge-base --is-ancestor 7b1622d1ab90f01fdb3a2bc24e12ab4990f07f68 HEAD; then
	        _lastcommit="bdeae71"
	      #elif git merge-base --is-ancestor 7e736b5903d3d078bbf7bb6a509536a942f6b9a0 HEAD; then
	      #  _lastcommit="7b1622d"
	      else
	        _lastcommit="none"
	      fi
	      if [ "$_lastcommit" != "none" ]; then
	        if [ "$_proton_fs_hack" = "true" ]; then
	          _patchname="proton-winevulkan-$_lastcommit.patch" && _patchmsg="Using Proton winevulkan patches" && nonuser_patcher
	        else
	          _patchname="proton-winevulkan-nofshack-$_lastcommit.patch" && _patchmsg="Using Proton winevulkan patches (nofshack)" && nonuser_patcher
	        fi
          fi
	    fi
	  fi
	fi

	# Enforce mscvrt Dlls to native then builtin - from Proton
	if [ "$_msvcrt_nativebuiltin" = "true" ]; then
	  if [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_protonify" = "true" ] && [ "$_unfrog" != "true" ]; then
	    if git merge-base --is-ancestor 51ffea5a3940bdc74b44b9303c4574dfb156efc0 HEAD; then
	      _patchname='msvcrt_nativebuiltin.patch' && _patchmsg="Enforce msvcrt Dlls to native then builtin (from Proton)" && nonuser_patcher
	    elif git merge-base --is-ancestor eafb4aff5a2c322f4f156fdfada5743834996be4 HEAD; then
	      _patchname='msvcrt_nativebuiltin-51ffea5a.patch' && _patchmsg="Enforce msvcrt Dlls to native then builtin (from Proton)" && nonuser_patcher
	    else
	      _patchname='msvcrt_nativebuiltin-eafb4aff.patch' && _patchmsg="Enforce msvcrt Dlls to native then builtin (from Proton)" && nonuser_patcher
	    fi
	  else
	    if git merge-base --is-ancestor 51ffea5a3940bdc74b44b9303c4574dfb156efc0 HEAD; then
	      _patchname='msvcrt_nativebuiltin_mainline.patch' && _patchmsg="Enforce msvcrt Dlls to native then builtin (from Proton)" && nonuser_patcher
	    fi
	  fi
	fi

	# Proton Bcrypt patches
	if [ "$_proton_bcrypt" = "true" ]; then
	  if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 74c0da2d71e95f3e6bd6c8b440652933771b27d7 HEAD );then
	    if [ "$_use_staging" = "true" ] && ! grep -Fxq 'Disabled: true' "${srcdir}/${_stgsrcdir}/patches/bcrypt-ECDHSecretAgreement/definition"; then
	      if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor b3cd21c21cf832529b154b3b8cc6ff85ec246c59 HEAD );then
	        _patchname='proton-bcrypt-staging.patch' && _patchmsg="Using Proton Bcrypt patches" && nonuser_patcher
	      elif ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 3db37dc5ae4e8b701c26f96fec97822b8b4da80c HEAD );then
	        _patchname='proton-bcrypt-staging-b3cd21c.patch' && _patchmsg="Using Proton Bcrypt patches" && nonuser_patcher
	      else
	        _patchname='proton-bcrypt-staging-3db37dc.patch' && _patchmsg="Using Proton Bcrypt patches" && nonuser_patcher
	      fi
	      ( cd "${srcdir}"/"${_winesrcdir}" && update_configure )
	    fi
	  fi
	fi

    # Joshua Ashton's take on making wine dialogs and menus less win95-ish - https://github.com/Joshua-Ashton/wine/tree/wine-better-theme
    if [ "$_use_josh_flat_theme" = "true" ]; then
      if git merge-base --is-ancestor 6456973f0a64d326bb54da4675310caffc2588f1 HEAD && ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
        _patchname='josh-flat-theme.patch' && _patchmsg="Add Josh's better-theme" && nonuser_patcher
      else
        _patchname='josh-flat-theme-6456973.patch' && _patchmsg="Add Josh's better-theme" && nonuser_patcher
      fi
    fi

	# Set the default wine version to win10
	if [ "$_win10_default" = "true" ] && [ "$_unfrog" != "true" ] && git merge-base --is-ancestor 74dc0c5df9c3094352caedda8ebe14ed2dfd615e HEAD; then
	  if git merge-base --is-ancestor d02d50299b236690738563e1db8c08d1cb603f76 HEAD; then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='proton-win10-default-staging.patch' && _patchmsg="Enforce win10 as default wine version (staging)" && nonuser_patcher
	    else
	      _patchname='proton-win10-default.patch' && _patchmsg="Enforce win10 as default wine version" && nonuser_patcher
	    fi
	  elif git merge-base --is-ancestor 39263558a2088940aaacd6eda19ca23d40b63495 HEAD; then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='proton-win10-default-staging-d02d502.patch' && _patchmsg="Enforce win10 as default wine version (staging)" && nonuser_patcher
	    else
	      _patchname='proton-win10-default-d02d502.patch' && _patchmsg="Enforce win10 as default wine version" && nonuser_patcher
	    fi
	  elif git merge-base --is-ancestor 595600b6c14c957d19f3ef8c0c82acacd7c6827a HEAD; then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='proton-win10-default-staging-3926355.patch' && _patchmsg="Enforce win10 as default wine version (staging)" && nonuser_patcher
	    else
	      _patchname='proton-win10-default-3926355.patch' && _patchmsg="Enforce win10 as default wine version" && nonuser_patcher
	    fi
	  elif git merge-base --is-ancestor 87f41e6b408dd01055ff6a378b90d089d61ec370 HEAD; then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='proton-win10-default-staging-595600b.patch' && _patchmsg="Enforce win10 as default wine version (staging)" && nonuser_patcher
	    else
	      _patchname='proton-win10-default-595600b.patch' && _patchmsg="Enforce win10 as default wine version" && nonuser_patcher
	    fi
	  elif git merge-base --is-ancestor e13d54665765d9dd8829233f0ea748fd685a1913 HEAD; then
	    if [ "$_use_staging" = "true" ]; then
	      _patchname='proton-win10-default-staging-87f41e6.patch' && _patchmsg="Enforce win10 as default wine version (staging)" && nonuser_patcher
	    else
	      _patchname='proton-win10-default-87f41e6.patch' && _patchmsg="Enforce win10 as default wine version" && nonuser_patcher
	    fi
	  else
	    _patchname='proton-win10-default-e13d546.patch' && _patchmsg="Enforce win10 as default wine version" && nonuser_patcher
	  fi
	fi

	# Add support for dxvk_config library to Wine's dxgi for Proton
	if ( [ "$_use_vkd3dlib" = "false" ] && [ "$_EXTERNAL_INSTALL" = "proton" ] && [ "$_protonify" = "true" ] && [ "$_unfrog" != "true" ] ) && git merge-base --is-ancestor 74dc0c5df9c3094352caedda8ebe14ed2dfd615e HEAD; then
	  if git merge-base --is-ancestor 591068cec06257f3d5ed23e19ee4ad055ad978aa HEAD; then
	    _patchname='dxvk_config_dxgi_support.patch' && _patchmsg="Add support for dxvk_config library to Wine's dxgi" && nonuser_patcher
	  else
	    _patchname='dxvk_config_dxgi_support-591068c.patch' && _patchmsg="Add support for dxvk_config library to Wine's dxgi" && nonuser_patcher
	  fi
	fi

	# Proton-tkg needs to know if standard dlopen() is in use
	if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor b87256cd1db21a59484248a193b6ad12ca2853ca HEAD ); then
	  _standard_dlopen="true"
	else
	  _standard_dlopen="false"
	fi

	echo -e "" >> "$_where"/last_build_config.log
	_commitmsg="04-post-staging" _committer
}

_polish() {
	# wine user patches
	_userpatch_target="plain-wine"
	_userpatch_ext="my"
	cd "${srcdir}"/"${_winesrcdir}"
	if [ "$_NUKR" != "debug" ] && [ "$_unfrog" != "true" ] || [[ "$_DEBUGANSW1" =~ [yY] ]]; then
	  if [ "$_LOCAL_PRESET" != "staging" ] && [ "$_LOCAL_PRESET" != "mainline" ] && [ -z "$_localbuild" ]; then
	    hotfixer && _commitmsg="05-hotfixes" _committer
	  fi
	fi
	if [ "$_user_patches" = "true" ]; then
	  user_patcher && _commitmsg="06-userpatches" _committer
	fi

	# UNFROG HOTFIX - Autoconf 2.70 fix for legacy trees - https://github.com/wine-mirror/wine/commit/d7645b67c350f7179a1eba749ec4524c74948d86
	if [ "$_unfrog" = "true" ] && ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor d7645b67c350f7179a1eba749ec4524c74948d86 HEAD ); then
	  patch -Np1 < "$_where"/wine-tkg-patches/hotfixes/autoconf-legacy-fix/autoconf-legacy-fix.mypatch
	fi

	echo "" >> "$_where"/last_build_config.log

	if [ -z "$_localbuild" ]; then
	  if [ "$_untag" != "true" ]; then
	    if [ "$_use_staging" = "true" ] && [ "$_LOCAL_PRESET" != "staging" ]; then
	      if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	        _patchname='wine-tkg-staging.patch' && _patchmsg="Please don't report bugs about this wine build on winehq.org and use https://github.com/Frogging-Family/wine-tkg-git/issues instead." && nonuser_patcher
	      else
	        _patchname='wine-tkg-staging-0c249e6.patch' && _patchmsg="Please don't report bugs about this wine build on winehq.org and use https://github.com/Frogging-Family/wine-tkg-git/issues instead." && nonuser_patcher
	      fi
	    elif [ "$_use_staging" != "true" ] && [ "$_LOCAL_PRESET" != "mainline" ]; then
	      if ( cd "${srcdir}"/"${_winesrcdir}" && git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	        _patchname='wine-tkg.patch' && _patchmsg="Please don't report bugs about this wine build on winehq.org and use https://github.com/Frogging-Family/wine-tkg-git/issues instead." && nonuser_patcher
	      elif git merge-base --is-ancestor c7760ce7a247eeb9f15b51d0ec68ca0961efc0b0 HEAD; then
	        _patchname='wine-tkg-0c249e6.patch' && _patchmsg="Please don't report bugs about this wine build on winehq.org and use https://github.com/Frogging-Family/wine-tkg-git/issues instead." && nonuser_patcher
	      else
	        _patchname='wine-tkg-c7760ce.patch' && _patchmsg="Please don't report bugs about this wine build on winehq.org and use https://github.com/Frogging-Family/wine-tkg-git/issues instead." && nonuser_patcher
	      fi
	    fi
	  fi
	else
	  # output config to logfile
	  echo "# Last $pkgname configuration - $(date) :" > "$_where"/last_build_config.log
	  echo "" >> "$_where"/last_build_config.log

	  # log config file in use
	  if [ -n "$_LOCAL_PRESET" ] && [ -e "$_where"/wine-tkg-profiles/wine-tkg-"$_LOCAL_PRESET".cfg ]; then
	    _cfgstringin="$_LOCAL_PRESET" && _cfgstring && echo "Local preset configuration file $_cfgstringout used" >> "$_where"/last_build_config.log
	  elif [ -n "$_EXT_CONFIG_PATH" ] && [ -e "$_EXT_CONFIG_PATH" ]; then
	    _cfgstringin="$_EXT_CONFIG_PATH" && _cfgstring && echo "External configuration file $_cfgstringout used" >> "$_where"/last_build_config.log
	  else
	    echo "Local cfg files used" >> "$_where"/last_build_config.log
	  fi
	fi

	# Get rid of temp patches
	rm -rf "$_where"/*.patch
	rm -rf "$_where"/*.my*
	rm -rf "$_where"/*.orig

	echo -e "\nRunning make_vulkan" >> "$_where"/prepare.log && dlls/winevulkan/make_vulkan >> "$_where"/prepare.log 2>&1
	tools/make_requests
	autoreconf -fiv

	# The versioning string has moved with 1dd3051cca5cafe90ce44460731df61abb680b3b
	# Since this is reverted by the hotfixer path, only use the new path on 0c249e6+ (deprecation of the hotfixer path)
	if ( cd "${srcdir}"/"${_winesrcdir}" && ! git merge-base --is-ancestor 0c249e6125fc9dc6ee86b4ef6ae0d9fa2fc6291b HEAD ); then
	  _versioning_path="${srcdir}/${_winesrcdir}/libs/wine/Makefile.in"
	  _versioning_string="top_srcdir"
	else
	  _versioning_path="${srcdir}/${_winesrcdir}/Makefile.in"
	  _versioning_string="srcdir"
	fi

	if [ -n "$_localbuild" ] && [ -n "$_localbuild_versionoverride" ]; then
	  sed -i "s/GIT_DIR=\$($_versioning_string)\\/.git git describe HEAD 2>\\/dev\\/null || echo \"wine-\$(PACKAGE_VERSION)\"/echo \"wine-$_localbuild_versionoverride\"/g" "$_versioning_path"
	elif [ -z "$_localbuild" ]; then
	  # Set custom version so that it reports the same as pkgver
	  sed -i "s/GIT_DIR=\$($_versioning_string)\\/.git git describe HEAD 2>\\/dev\\/null || echo \"wine-\$(PACKAGE_VERSION)\"/echo \"wine-$_realwineversion\"/g" "$_versioning_path"

	  # Set custom version tags
	  local _version_tags=()
	  _version_tags+=(TkG) # watermark to keep track of TkG builds independently of the settings
	  if [ "$_use_staging" = "true" ]; then
	    _version_tags+=(Staging)
	  else
	    _version_tags+=(Plain)
	  fi
	  if [ "$_use_esync" = "true" ] || [ "$_staging_esync" = "true" ]; then
	   _version_tags+=(Esync)
	  fi
	  if [ "$_use_fsync" = "true" ] && [ "$_staging_esync" = "true" ]; then
	    _version_tags+=(Fsync)
	  fi
	  if [ "$_use_pba" = "true" ] && [ "$_pba_version" != "none" ]; then
	    _version_tags+=(PBA)
	  fi
	  if [ "$_use_legacy_gallium_nine" = "true" ]; then
	    _version_tags+=(Nine)
	  fi
	  if [ "$_use_vkd3dlib" = "false" ]; then
	    if [ "$_dxvk_dxgi" != "true" ] && git merge-base --is-ancestor 74dc0c5df9c3094352caedda8ebe14ed2dfd615e HEAD; then
	      _version_tags+=(Vkd3d DXVK-Compatible)
	    fi
	  fi
	  sed -i "s/\"\\\1.*\"/\"\\\1  ( ${_version_tags[*]} )\"/g" "${_versioning_path}"
	  sed -i "s/\"\\\1.*\"/\"\\\1  ( ${_version_tags[*]} )\"/g" "${srcdir}"/"${_winesrcdir}"/dlls/ntdll/Makefile.in
	fi

	# fix path of opencl headers
	sed 's|OpenCL/opencl.h|CL/opencl.h|g' -i configure*

	_commitmsg="07-tags-n-polish" _committer

	if [ "$_NUKR" != "debug" ]; then
	  # delete old build dirs (from previous builds)
	  rm -rf "${srcdir}"/wine-tkg-*-{32,64}-build
	fi

	# no compilation
	if [ "$_NOCOMPILE" = "true" ]; then
	  cp -u "$_where"/last_build_config.log "${srcdir}"/"${_winesrcdir}"/wine-tkg-config.txt
	fi

	cd "$_where" # this is needed on version update not to get lost in srcdir
}

_makedirs() {
	# Nuke if present then create new build dirs
	if [ "$_NUKR" = "true" ] && [ "$_SKIPBUILDING" != "true" ]; then
	  rm -rf "${srcdir}"/"${pkgname}"-64-build
	  rm -rf "${srcdir}"/"${pkgname}"-32-build
	fi
	mkdir -p "${srcdir}"/"${pkgname}"-64-build
	mkdir -p "${srcdir}"/"${pkgname}"-32-build
}

# Workaround
trap _exit_cleanup EXIT
