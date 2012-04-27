## Introduction

Skewer is a tool that helps you run Puppet code on arbitrary
machines. Skewer can:

  1. Spawn a new virtual machine via a cloud system
  2. Provision it with puppet code
  3. Update the puppet code on a machine that you've provisioned already
  4. Delete it

Skewer exists because sometimes, a Puppet master server isn't needed.
If you run a small number of nodes, or simply want to bootstrap 
cloud nodes, you might like this tool.

## Design Goals

At Build Doctor HQ, we love Puppet. We don't love:

  - The overhead of a server when using a small number of nodes
  - Stale operating system packaging
  - RubyGems

We did use Lindsay Holmwood's excellent Rump, but settled on a
different approach:

  - We deploy Puppet with RubyGems
  - We tame RubyGems with Bundler
  - We ensure that bundler works with your operating system.

Once a server is bootstrapped into existence, your code is rsynced
over to the remote machine. An annoyance of previous incarnations was
testing changes to systems. So this approach lets you roll out code
in any state of development to test on a real system. We recommend
that you use Vagrant too, but you can't reproduce every feature of a
cloud VM on a Vagrantbox. There's no substitute for 19 inches (of
rack-mounted hardware).

## Installation

You can install Skewer via RubyGems like so:

    $ gem install skewer

## Usage

To get started you'll need to create a Fog configuration file:

    $ touch ~/.fog

Then add your cloud service credentials, AWS EC2 or Rackspace for
example, to the file:

    :default:
      :aws_access_key_id: AKIAIISJV5TZ3FPWU3TA
      :aws_secret_access_key: ABCDEFGHIJKLMNOP1234556/s

To provision a node you can run `skewer provision`. You will need to provide the name 
of the cloud service you wish to use, the name of the image (for example for EC2 you need 
to provide an AMI image ID) you wish to provision, and the role of the node you wish to
create:

    $ skewer provision --cloud ec2 --image ami1234 --role webserver --key ec2-key

In this case we're using EC2 so we've also added the `--key` option to
specify an AWS security key.

This will provision a new node and configure it with the `webserver` role.

If the node is already running you can also update it using the `skewer
update` command like so:

    $ skewer update --host hostname --user user --role webserver

This assumes you have SSH access to the host.

Finally, if you wish to delete a node you can do that using the `skewer
delete` command:

    $ skewer delete --cloud ec2 --host hostname

If you wish to override any of the default options you can create a
`.skewer` file to configure Skewer.

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

To run the cucumber features, you'll need vagrant and VirtualBox
installed. You'll also need to hack the SSH configuration in order to allow
the cucumber features to hit the vagrant box:

    vagrant ssh_config >> ~/.ssh/config
