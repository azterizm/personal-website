export default function (config) {
  // The public CV is built locally by cv/build.sh and committed. The portal copy with the phone stays in cv/private/.
  config.addPassthroughCopy({ "cv/out/Abdullah_Memon_CV.pdf": "Abdullah_Memon_CV.pdf" });

  return {
    dir: { input: "src", output: "_site" },
  };
}
