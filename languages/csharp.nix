{
  full,
  pkgs,
  ...
}: let
  unity_analyzer = pkgs.fetchNuGet {
    pname = "Microsoft.Unity.Analyzers";
    version = "1.19.0";
    sha256 = "sha256-MM2hhRqvvau5VGvSkDs8A/X5PMNYSSEnPnFg+LxO8H0=";
    outputFiles = ["analyzers/dotnet/cs/Microsoft.Unity.Analyzers.dll"];
  };
in {
  vim = {
    languages.csharp = {
      enable = full;
      lsp.servers = ["roslyn-ls"];

      extensions.roslyn-nvim.enable = true;
    };
    lsp.servers.roslyn-ls.settings = {
      "csharp|completion".dotnet_trigger_completion_in_argument_lists = true;
      "csharp|projects" = {
        dotnet_binary_log_path = null;
        dotnet_enable_automatic_restore = true;
        dotnet_enable_file_based_programs = true;
        dotnet_enable_file_based_programs_when_ambiguous = true;
      };
      "csharp|navigation" = {
        dotnet_navigate_to_decompiled_sources = true;
        dotnet_navigate_to_source_link_and_embedded_sources = true;
      };
      "csharp|highlighting" = {
        dotnet_highlight_related_json_components = true;
        dotnet_highlight_related_regex_components = true;
      };
    };
    luaConfigRC.print_unity_analyzer_path = ''
      vim.api.nvim_create_user_command('UnityAnalyzerPath', 'echo "${unity_analyzer}/lib/dotnet/Microsoft.Unity.Analyzers/Microsoft.Unity.Analyzers.dll"', {})
    '';
  };
}
