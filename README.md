# lua-obfuscator-samples

A continuously updated collection of real-world Lua obfuscator samples, automatically collected and categorized by obfuscator type and version.

---

## 📁 Structure

```
samples/
├── Luraph/
│   ├── v14.7/
│   └── v15.x/
├── MoonSec/
├── Moonveil/
├── IronBrew/
├── Prometheus/
├── PSU/
├── Alcatraz/
├── ByteCode/
├── Skido/
└── Custom_Obfuscator/
```

Each subfolder may be further divided by version when detected. Samples are named `<message_id>_<original_name>.lua` to guarantee uniqueness.

---

## 🔄 Sample Source

All samples are extracted automatically from the **[SynCrypt Discord server](https://discord.gg/syncrypt)**, specifically from ZigZag bot interactions in their public obfuscator detection channel.

Samples are collected in real time and the dataset is **continuously renewed** as new scripts are submitted by the community. The collection is never static — new obfuscator versions and techniques appear regularly.

---

## ⚠️ Disclaimer

> **This repository is provided strictly for educational and research purposes.**

- The samples collected here are scripts submitted publicly by third-party users to the SynCrypt Discord server. They were not created by the maintainers of this repository.
- The maintainers of this repository **do not claim ownership** over any of the collected scripts and are **not responsible** for what the original authors used them for.
- The maintainers of this repository are **not liable** for any damages, legal issues, or misuse arising from the use, analysis, or redistribution of these samples.
- These samples are intended solely for **reverse engineering research**, **obfuscator analysis**, and **deobfuscation tooling development**.
- **Do not use these samples for malicious purposes.** Using obfuscated scripts to cheat, exploit, or harm others is entirely your own responsibility.

By accessing or using the contents of this repository, you agree that you understand and accept the above terms.

---

## 📊 Coverage

| Obfuscator | Samples | Notes |
|---|---|---|
| Luraph | ✅ | Multiple versions |
| MoonSec | ✅ | v2 and v3 |
| Moonveil | ✅ | |
| IronBrew | ✅ | v2 and v3 |
| Prometheus | ✅ | |
| PSU | ✅ | |
| Alcatraz | ✅ | |
| ByteCode | ✅ | |
| Skido | ✅ | |
| Custom / Unknown | ✅ | Unrecognized obfuscators |

Coverage expands as new obfuscators appear in the wild.

---

## 📄 License

The samples in this repository are third-party content — no license is granted over them by this repository.

https://discord.gg/syncrypt
