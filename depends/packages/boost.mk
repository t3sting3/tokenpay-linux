package=boost
$(package)_version=1_65_1
$(package)_download_path=https://archives.boost.io/release/1.65.1/source/
$(package)_file_name=$(package)_$($(package)_version).tar.bz2
$(package)_sha256_hash=9807a5d16566c57fd74fb522764e0b134a8bbe6b6e8967b83afefd30dcd3be81

$(package)_compiler=
ifeq ($(CLANG_ARG),true)
$(package)_compiler=clang
else
$(package)_compiler=gcc
endif

define $(package)_set_vars
$(package)_config_opts_release=variant=release
$(package)_config_opts_debug=variant=debug
$(package)_config_opts=--layout=system
$(package)_config_opts+=threading=multi link=static -sNO_BZIP2=1 -sNO_ZLIB=1
$(package)_config_opts_linux=threadapi=pthread runtime-link=shared
$(package)_config_opts_darwin=--toolset=darwin-4.2.1 runtime-link=shared
$(package)_config_opts_mingw32=binary-format=pe target-os=windows threadapi=win32 runtime-link=static
$(package)_config_opts_x86_64_mingw32=address-model=64
$(package)_config_opts_i686_mingw32=address-model=32
$(package)_config_opts_i686_linux=address-model=32 architecture=x86
$(package)_toolset_$(host_os)=$($(package)_compiler)
$(package)_archiver_$(host_os)=$($(package)_ar)
$(package)_toolset_darwin=darwin
$(package)_archiver_darwin=$($(package)_libtool)
$(package)_config_libraries=chrono,filesystem,date_time,program_options,iostreams,system,thread,test
$(package)_cxxflags=-std=c++11 -fvisibility=hidden
$(package)_cxxflags_linux=-fPIC
$(package)_cxxflags_freebsd=-fPIC
endef

define $(package)_config_cmds
  ./bootstrap.sh --with-toolset=$($(package)_compiler) --without-icu --with-libraries=$($(package)_config_libraries) && \
  sed -i -e "s|using $($(package)_compiler) ;|using $($(package)_toolset_$(host_os)) : : $($(package)_cxx) : <cxxflags>\"$($(package)_cxxflags) $($(package)_cppflags)\" <linkflags>\"$($(package)_ldflags)\"<archiver>\"$($(package)_archiver_$(host_os))\" <striper>\"$(host_STRIP)\"  <ranlib>\"$(host_RANLIB)\" <rc>\"$(host_WINDRES)\" : ;|" project-config.jam
endef

define $(package)_build_cmds
  ./b2 -d2 -j2 -d1 --prefix=$($(package)_staging_prefix_dir) $($(package)_config_opts) stage
endef

define $(package)_stage_cmds
  ./b2 -d0 -j4 --prefix=$($(package)_staging_prefix_dir) $($(package)_config_opts) install
endef