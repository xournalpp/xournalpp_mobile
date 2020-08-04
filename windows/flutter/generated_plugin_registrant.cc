//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <url_launcher_fde/url_launcher_plugin.h>
#include <file_chooser/file_chooser_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  UrlLauncherPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherPlugin"));
  FileChooserPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileChooserPlugin"));
}
