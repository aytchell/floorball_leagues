final String logoHost = 'saisonmanager.de';

Uri? buildLogoUri(String? path) {
  if (path == null) {
    return null;
  } else {
    return Uri(scheme: 'https', host: logoHost, path: path);
  }
}
