# -*- mode: ruby -*-
# vi: set ft=ruby :
##############################################################################
# Copyright (c) 2019
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

$no_proxy = ENV['NO_PROXY'] || ENV['no_proxy'] || "127.0.0.1,localhost"
(1..254).each do |i|
  $no_proxy += ",10.0.2.#{i}"
end
$debug = ENV['PKG_DEBUG'] || "true"

File.exists?("/usr/share/qemu/OVMF.fd") ? loader = "/usr/share/qemu/OVMF.fd" : loader = File.join(File.dirname(__FILE__), "OVMF.fd")
if not File.exists?(loader)
  system('curl -O https://download.clearlinux.org/image/OVMF.fd')
end

distros = YAML.load_file(File.dirname(__FILE__) + '/distros_supported.yml')

Vagrant.configure("2") do |config|
  config.vm.provider :libvirt
  config.vm.provider :virtualbox

  config.vm.synced_folder './', '/vagrant', type: "rsync",
    rsync__args: ["--verbose", "--archive", "--delete", "-z"]
  distros["linux"].each do |distro|
    config.vm.define distro["alias"] do |node|
      node.vm.box = distro["name"]
      if distro.has_key? "version"
        node.vm.box_version = distro["version"]
      end
      node.vm.box_check_update = false
      if distro["alias"] == "clearlinux"
        node.vm.provider 'libvirt' do |v|
          v.loader = loader
        end
      end
    end
  end

  $vagrant_root = File.dirname(__FILE__)
  config.vm.provision 'shell', path: "#{$vagrant_root}/_requirements.sh"
  config.vm.provision 'shell', privileged: false do |sh|
    sh.env = {
      'PKG_DEBUG': "#{$debug}",
    }
    sh.inline = <<-SHELL
      set -o errexit
      if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
          set -o xtrace
      fi

      cd /vagrant
      rm -f ~/{main,validate}.log
      for test_script in $(ls tests/*sh ); do
          test_case=${test_script%.sh}
          bash $test_script | tee --append ~/validate.log ~/main.log | tee ~/${test_case##*/}.log
      done
      echo "Tests completed!!!"
    SHELL
  end

  [:virtualbox, :libvirt].each do |provider|
  config.vm.provider provider do |p|
      p.cpus = ENV['CPUS'] || 1
      p.memory = ENV['MEMORY'] || 512
    end
  end

  config.vm.provider "virtualbox" do |v|
    v.gui = false
  end

  config.vm.provider :libvirt do |v|
    v.random_hostname = true
    v.management_network_address = "10.0.2.0/24"
    v.management_network_name = "administration"
    v.cpu_mode = 'host-passthrough'
  end

  if ENV['http_proxy'] != nil and ENV['https_proxy'] != nil
    if Vagrant.has_plugin?('vagrant-proxyconf')
      config.proxy.http     = ENV['http_proxy'] || ENV['HTTP_PROXY'] || ""
      config.proxy.https    = ENV['https_proxy'] || ENV['HTTPS_PROXY'] || ""
      config.proxy.no_proxy = $no_proxy
      config.proxy.enabled = { docker: false, git: false }
    end
  end
end
