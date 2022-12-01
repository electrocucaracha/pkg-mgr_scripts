# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :
##############################################################################
# Copyright (c) 2019
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

no_proxy = ENV["NO_PROXY"] || ENV["no_proxy"] || "127.0.0.1,localhost"
(1..254).each do |i|
  no_proxy += ",10.0.2.#{i}"
end
debug = ENV["PKG_DEBUG"] || "true"

distros = YAML.load_file("#{File.dirname(__FILE__)}/distros_supported.yml")

Vagrant.configure("2") do |config|
  config.vm.provider :libvirt
  config.vm.provider :virtualbox

  config.vm.synced_folder "./", "/vagrant"
  distros["linux"].each do |distro|
    config.vm.define distro["alias"] do |node|
      node.vm.box = distro["name"]
      node.vm.box_version = distro["version"] if distro.key? "version"
      node.vm.box_check_update = false
    end
  end

  vagrant_root = File.dirname(__FILE__)
  config.vm.provision "shell", path: "#{vagrant_root}/_requirements.sh"
  config.vm.provision "shell", privileged: false do |sh|
    sh.env = {
      PKG_DEBUG: debug.to_s
    }
    sh.inline = <<-SHELL
      set -o errexit
      if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
          set -o xtrace
      fi

      cd /vagrant
      rm -f ~/{install,validate}.log
      for test_script in $(ls test/*sh ); do
          test_case=${test_script%.sh}
          bash $test_script | tee --append ~/validate.log ~/install.log | tee ~/${test_case##*/}.log
      done
      echo "Tests completed!!!"
    SHELL
  end

  host = RbConfig::CONFIG["host_os"]

  case host
  when /darwin/
    mem = `sysctl -n hw.memsize`.to_i / 1024
  when /linux/
    mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i
  when /mswin|mingw|cygwin/
    mem = `wmic computersystem Get TotalPhysicalMemory`.split[1].to_i / 1024
  end
  %i[virtualbox libvirt].each do |provider|
    config.vm.provider provider do |p|
      p.cpus = 1
      p.memory = ENV["MEMORY"] || (mem / 1024 / 4)
    end
  end

  config.vm.provider "virtualbox" do |v|
    v.gui = false
    v.customize ["modifyvm", :id, "--nictype1", "virtio", "--cableconnected1", "on"]
    # Enable nested paging for memory management in hardware
    v.customize ["modifyvm", :id, "--nestedpaging", "on"]
    # Use large pages to reduce Translation Lookaside Buffers usage
    v.customize ["modifyvm", :id, "--largepages", "on"]
    # Use virtual processor identifiers  to accelerate context switching
    v.customize ["modifyvm", :id, "--vtxvpid", "on"]
  end

  config.vm.provider "libvirt" do |v, override|
    override.vm.synced_folder "./", "/vagrant", type: "nfs", nfs_version: ENV.fetch("VAGRANT_NFS_VERSION", 3)
    v.random_hostname = true
    v.management_network_address = "10.0.2.0/24"
    v.management_network_name = "administration"
    v.cpu_mode = "host-passthrough"
  end

  if !ENV["http_proxy"].nil? && !ENV["https_proxy"].nil? && Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http = ENV["http_proxy"] || ENV["HTTP_PROXY"] || ""
    config.proxy.https    = ENV["https_proxy"] || ENV["HTTPS_PROXY"] || ""
    config.proxy.no_proxy = no_proxy
    config.proxy.enabled = { docker: false, git: false }
  end
end
