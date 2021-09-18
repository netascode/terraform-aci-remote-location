terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

module "main" {
  source = "../.."

  name          = "RL1"
  description   = "My Description"
  hostname_ip   = "1.1.1.1"
  auth_type     = "password"
  protocol      = "ftp"
  path          = "/"
  port          = 21
  username      = "user1"
  password      = "password"
  mgmt_epg      = "oob"
  mgmt_epg_name = "OOB1"
}

data "aci_rest" "fileRemotePath" {
  dn = "uni/fabric/path-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fileRemotePath" {
  component = "fileRemotePath"

  equal "name" {
    description = "name"
    got         = data.aci_rest.fileRemotePath.content.name
    want        = module.main.name
  }

  equal "host" {
    description = "host"
    got         = data.aci_rest.fileRemotePath.content.host
    want        = "1.1.1.1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.fileRemotePath.content.descr
    want        = "My Description"
  }

  equal "authType" {
    description = "authType"
    got         = data.aci_rest.fileRemotePath.content.authType
    want        = "usePassword"
  }

  equal "protocol" {
    description = "protocol"
    got         = data.aci_rest.fileRemotePath.content.protocol
    want        = "ftp"
  }

  equal "remotePath" {
    description = "remotePath"
    got         = data.aci_rest.fileRemotePath.content.remotePath
    want        = "/"
  }

  equal "remotePort" {
    description = "remotePort"
    got         = data.aci_rest.fileRemotePath.content.remotePort
    want        = "21"
  }

  equal "userName" {
    description = "userName"
    got         = data.aci_rest.fileRemotePath.content.userName
    want        = "user1"
  }
}

data "aci_rest" "fileRsARemoteHostToEpg" {
  dn = "${data.aci_rest.fileRemotePath.id}/rsARemoteHostToEpg"

  depends_on = [module.main]
}

resource "test_assertions" "fileRsARemoteHostToEpg" {
  component = "fileRsARemoteHostToEpg"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.fileRsARemoteHostToEpg.content.tDn
    want        = "uni/tn-mgmt/mgmtp-default/oob-OOB1"
  }
}
