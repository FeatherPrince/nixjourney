{ llama-cpp-latest, ... }: final: prev: {
  llama-cpp-rocm = prev.llama-cpp-rocm.overrideAttrs (old: {
    src = llama-cpp-latest;
  });
}
