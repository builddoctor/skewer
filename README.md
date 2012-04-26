## Introduction

Skewer is a tool that helps you run Puppet code on arbitrary
machines. Skewer can:

  1. Spawn a new virtual machine via a cloud system
  2. Provision it with puppet code
  3. Update the puppet code on a machine that you've provisioned already
  4. Delete it

Skewer exists because sometimes, a Puppetmaster server isn't needed.
If you run a small number of nodes, or simply want to bootstrap 
cloud nodes, you might like this tool.

## Design Goals

At Build Doctor HQ, we love Puppet. We don't love:

  - The overhead of a server when using a small number of nodes
  - Stale operating system packaging
  - Rubygems

We did use Lindsay Holmwood's excellent Rump, but settled on a
different approach:

  - We deploy Puppet with Rubygems
  - We tame rubygems with Bundler
  - We ensure that bundler works with your operating system.

Once a server is bootstrapped into existence, your code is rsynced
over to the remote machine. An annoyance of previous incarnations was
testing changes to systems. So this approach lets you roll out code
in any state of development to test on a real system (we recommend
that you use Vagrant too, but you can't reproduce every feature of a
cloud VM on a Vagrantbox. There's no substute for 19 inches (of
rack-mounted hardware).

## Installation

You can install Skewer via RubyGems like so:

    $ gem install skewer

## Usage

`skewer provision` will provision a new node, and `skewer update` will allow
you to roll out new changes. Using `skewer delete` you can delete a node 
already in one of the supported cloud providers.

To provision, you'll need to have:

  - A fog configuration file to tell skewer how to access your cloud service,
  - Image information (e.g. AMI id) for the cloud service you want to access
  - A .skewer file (optional) to store options in, if you don't like
    the defaults

To update, you'll need a hostname and a username. We assume that you have access via SSH public key at this stage.

Supported clouds:

  - AWS (Sorry to be so predictable)
  - Rackspace

Supported operating systems:

  - Ubuntu (Hardy onwards)

## Development

This is a fully open source project. It's grown up over years as a
private project before being re-written with unit and acceptance
tests.

We use rspec, cucumber, aruba and rcov - that's 3 out of 4 from Aslak
Hellesoy.

Pull requests are welcomed!

To run the cucumber features, you'll need vagrant and virtualbox
installed. You'll also need to hack the ssh config in order to allow
the cucumber features to hit the vagrant box:

    vagrant ssh_config >> ~/.ssh/config
