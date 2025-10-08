#adapted from faster_whisper README

import faulthandler
faulthandler.enable(all_threads=True)

# if ROCM_PATH is defined, add it to dll loading path
import os
print(os.environ.get("ROCM_PATH", "ROCM_PATH not set"))
if "ROCM_PATH" in os.environ:
    os.add_dll_directory(os.path.join(os.environ["ROCM_PATH"], "bin"))

print(os.environ.get("INTEL_ROOT", "INTEL_ROOT not set"))
if "INTEL_ROOT" in os.environ:
    # scan for all folders that contains /latest/bin
    # # and add them to dll loading path
    for root, dirs, files in os.walk(os.path.join(os.environ["INTEL_ROOT"]), topdown=True):
        for name in dirs:
            if name == "latest":
                latest_path = os.path.join(root, name, "bin")
                if os.path.exists(latest_path):
                    print(f"Adding {latest_path} to DLL directories")
                    os.add_dll_directory(latest_path)

from faster_whisper import WhisperModel
import timeit

def run_test():
    segments, info = model.transcribe("tests/data/physicsworks.wav", beam_size=5, language="en")
    for segment in segments:
        print("[%.2fs -> %.2fs] %s" % (segment.start, segment.end, segment.text))

#don't include model load in bench
model_size = "medium"
model = WhisperModel(model_size, device="cuda", compute_type="float16")
# model = WhisperModel(model_size, device="cpu", compute_type="auto")
print(timeit.timeit("run_test()", globals=locals(), number=1))
