let
  fmt-cmd = builtins.replaceStrings [ "\n" ] [ " " ];

  model =
    {
      name,
      args,
      ctx ? 131072,
    }:
    let
      cmd = ''
        llama-server --port ''${PORT}
        -c ${toString ctx}
      '';

      preset-cmd = p-args: fmt-cmd (cmd + p-args + args);
    in
    {
      "${name}" = {
        cmd = preset-cmd ''
          --temp 1.0
          --top-p 0.95
          --top-k 20
          --presence-penalty 1.5
          --repeat_penalty 1.0
          --reasoning on
        '';
      };

      "${name}-coding" = {
        cmd = preset-cmd ''
          --temp 0.6
          --top-p 0.95
          --top-k 20
          --repeat_penalty 1.0
          --reasoning on
        '';
      };

      "${name}-nothink" = {
        cmd = preset-cmd ''
          --temp 0.0
          --top-p 0.8
          --top-k 20
          --presence-penalty 1.5
          --repeat_penalty 1.0
          --reasoning off
        '';
        filter = {
          stripParams = "temperature, top_p, top_k";
        };
      };
    };
in
{
  healthCheckTimeout = 900;
  globalTTL = 1200;
  captureBuffer = 0;

  models = builtins.foldl' (x: y: x // y) { } [
    (model {
      name = "qwen3.6-27b";
      args = ''
        -hf unsloth/Qwen3.6-27B-GGUF:Q4_K_M
      '';
    })
    (model {
      name = "qwen3.5-9bspec";
      args = ''
        -hf unsloth/Qwen3.5-9B-GGUF:Q4_K_M
        -hfd unsloth/Qwen3.5-0.8B-GGUF:Q4_K_M
      '';
    })
    (model {
      name = "qwen3.5-9b";
      args = ''
        -hf unsloth/Qwen3.5-9B-GGUF:Q4_K_M
      '';
    })
    (model {
      name = "qwen3.5-4b";
      args = ''
        -hf unsloth/Qwen3.5-4B-GGUF:Q4_K_M
      '';
    })
    (model {
      name = "qwen3.5-2b";
      args = ''
        -hf unsloth/Qwen3.5-2B-GGUF:Q4_K_M
      '';
    })
    (model {
      name = "gemma4-31b";
      args = ''
        -hf unsloth/gemma-4-31B-it-GGUF:Q4_K_M
      '';
      ctx = 65536;
    })
    (model {
      name = "gemma4-26b-a4b";
      args = ''
        -hf unsloth/gemma-4-26B-A4B-it-GGUF:Q4_K_M
      '';
    })
    (model {
      name = "gemma4-12b";
      args = ''
        -hf unsloth/gemma-4-12B-it-GGUF:Q4_K_M
      '';
    })
    (model {
      name = "gemma4-e4b";
      args = ''
        -hf unsloth/gemma-4-E4B-it-GGUF:Q4_K_M
      '';
    })
  ];

}
