{ goi3bar-src, buildGoModule, ... }:

buildGoModule {
  name = "goi3bar";
  version = "0.0.0";

  src = goi3bar-src;

  vendorSha256 = "sha256-0zadArU0PjoSkIepep8PzvQis0POkEmOeo5Up7DB9CA=";
}
