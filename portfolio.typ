#set page(margin: (0.5in), paper: "us-letter")
#set text(font: "New Computer Modern", lang: "en", size: 12pt)
#set document(title: "william_snow_iv_portfolio")
#let accent = rgb("#26428b");

#show link: set text(
  fill: rgb(accent),
)

#show heading: set text(
  fill: rgb(accent),
)

#show heading.where(level: 1): it => [
  #set text(
    weight: 700,
    size: 20pt,
  )
  #pad(it.body)
]

#show heading.where(level: 2): it => [
  #pad(top: 0pt, bottom: -10pt, [#smallcaps(it.body)])
  #line(length: 100%, stroke: 1pt)
]


= William (Liam) Snow IV
#text(size: 11pt)[
  #link("mailto:mail@liamsnow.com")[mail\@liamsnow.com]
  | #link("https://github.com/liamsnow")[github.com/liamsnow]
  | #link("https://linkedin.com/in/william-snow-iv-140438169")[linkedin.com/in/william-snow-iv-140438169]
  | #link("https://liamsnow.com")[liamsnow.com]
]

== Introduction
Hi! I'm Liam Snow, a 22 year old programmer from California.
I love tackling problems that seem impossible and am restless about quality.
As much as I love computers, I value the people I work with above everything else.


== Table of Contents
- #text(size: 13pt)[#link(<opensleep>)[*opensleep*]]: Open source firmware for the Eight Sleep Pod 3
- #text(size: 13pt)[#link(<liamsnow.com>)[*liamsnow.com*]]: Fast personal website made with Rust & Typst, hosted on Helios illumos
- #text(size: 13pt)[#link(<igloo>)[*igloo*]]: A powerful DIY smart home Rust library


== External Writings <ext>
+ #link("https://liamsnow.com/blog/cache_coherence")[Cache Coherence]: Why you should care about cache coherence protocols.
+ #link("https://liamsnow.com/blog/igloo/wasm")[Why not WASM]: What WebAssembly is, the ecosystem around it, my attempts at integrating it into Igloo, and why I ultimately decided it wasn’t ready yet.
+ #link("https://liamsnow.com/blog/igloo/shmem")[Distributed Device Tree & New IPC]: Improving Igloo's device tree, IPC, and query engine
  - From 1 million queries per second to over 1 billion
  - Covers shared memory, ring buffers, atomics, seqlocks, and more
+ #link("https://liamsnow.com/blog/igloo/penguin")[Igloo Penguin]: Making a blazingly fast node-based editor in Rust WebAssembly
+ #link("https://liamsnow.com/projects/homelab")[HomeLab]: The story of my home lab (a server rack in my closet).
  - Arch Linux → Kubernetes (Talos + k8s) → NixOS → Helios illumos
  - Open-source work 




#pagebreak()
= opensleep <opensleep>

#link("https://liamsnow.com/projects/opensleep")[Post] | #link("https://github.com/liamsnow/opensleep")[GitHub]


== Background  
The #link("https://www.eightsleep.com/blog/announcing-pod-3/")[Eight Sleep Pod 3] is a smart mattress cover that provides temperature control and sleep tracking. Around two years ago, I acquired a broken one and fixed it.

I was frustrated that many features of the bed were paywalled behind a monthly subscription. Furthermore, I was concerned that it streams raw sleep-tracking data to Eight Sleep's servers at all times. The #link("https://x.com/m_franceschetti/status/1726732560770666979")[CEO makes it very clear] that he has access to everyone's sleep tracking data. Everyone at Eight Sleep knows when you’re in bed, how many people are in bed, your sleep patterns, and more. They also have an #link("https://trufflesecurity.com/blog/removing-jeff-bezos-from-my-bed")[SSH backdoor into your bed]. Sadly, there’s no simple solution to these problems, as blocking it from the internet breaks the mobile app. 

== Version 1  
After some digging, I found articles about people hacking into their Eight Sleep pods. Basically, you take apart your Pod, edit the backup Yocto Linux install to include your WiFi and SSH keys, and trigger a factory reset. Once inside, you can see that the mobile app communicates to a TypeScript project called the Device-API-Client (DAC), which then sends commands to the C++ firmware, Frank, over a Unix Socket. One project, #link("https://github.com/bobobo1618/ninesleep")[ninesleep], replaces the DAC with a Rust program that exposes a local "raw" REST API to communicate with the firmware.

While ninesleep is a great project, I wanted automatic control of the bed, as you would get from the mobile app. I created a #link("https://github.com/LiamSnow/opensleep/tree/89ec7f39edceb2ad016dabdfdc469139db87eea7")[fork], cleaned up the code, and added many features, such as alarms and temperature profiles. I was very happy with it and used it for about a year.

== Version 2  
For a long time, I wanted to set up automations around the sensors on the bed. For example, reading my calendar and turning off my alarm when I got out of bed in the morning. My first attempt involved editing `/etc/hosts` so that the firmware would send me the sleep-tracking data. Sadly, this would only receive batches, which meant it wouldn’t work for the automations I wanted.

Getting sensor data immediately would require completely replacing Frank. This is a lot more work – instead of recreating a TypeScript project, I would need to reverse-engineer and recreate a C++ binary. I started by making diagrams and #link("https://github.com/LiamSnow/opensleep/blob/main/BACKGROUND.md")[notes] to figure out the hardware. I learned that Frank communicates with two STM32 microcontrollers over UART: "Frozen" to control everything water (pumping, priming, heating, and cooling) and "Sensor" to collect data from all sensors (capacitance, piezo, temperature). If I were able to reverse-engineer the UART protocols, I could replace Frank and access the sensor data I wanted.

Using strace, I learned the basic protocol structure, which allowed me to create a more formal tool, Fiona. Fiona runs Frank, traces it, and uses parts of opensleep v1 to send commands to it. I iteratively built out Fiona, applying what I learned about the protocol back into itself. Fiona taught me all the commands and transaction structure, but almost nothing about how to deserialize the payloads. Given that this protocol is completely bespoke, reverse-engineering it was purely educated guesswork and grit.

Once I knew enough, I created two Rust crates that implemented these protocols. Naively, I built a system that would scan for the start byte and then read packets. It was flawed because it could get "stuck" between packets. If it thought it had found a start byte but was actually in the middle of the payload, it could read the end of that packet and halfway into the next, missing the next actual start byte. I quickly replaced this with a #link("https://github.com/LiamSnow/opensleep/blob/main/src/common/codec.rs")[Tokio codec] that skips until the start byte; if the packet fails to deserialize, it only skips that start byte.

The Sensor protocol was particularly hard to reverse-engineer and implement, taking a few attempts. Frank would connect at a low baud rate, configure the sensors, ask it to upgrade to a higher baud rate, configure additional settings, and then start receiving sensor data. I initially recreated this behavior exactly, which quickly ran into problems. It didn’t have configuration retries because it didn’t understand the payload, and it wouldn’t properly space out commands, which broke the protocol or led to dropped messages.

Eventually, I managed to deserialize the payloads for configuration commands and their responses. Using this, I made a scheduler that handles configuration retries and staggers interval-based commands, ensuring everything is properly spaced. While building this, I realized that the microcontroller remains at a higher baud rate after disconnection for a long time. Even though Frank doesn’t handle this, I decided to make a #link("https://github.com/LiamSnow/opensleep/blob/f2d1c7f82ad746b33c2437a667ce4c69ac93cd96/src/sensor/manager.rs#L290")[discovery] mechanism to do it. With the discovery mechanism, command scheduler, and Tokio codec, I created an extremely robust implementation of the protocol. I have yet to find anything that breaks this protocol, even after running it for months.

When building out these Rust crates, I disabled all Eight Sleep processes. After a reboot, I noticed that the microcontrollers wouldn’t work without their C\# "supervisor" and Bluetooth setup program, Capybara. While digging through Capybara and the Yocto Linux setup, I discovered some I2C commands. These commands control an I2C multiplexer that both enables the microcontrollers and controls the front LED. Enabling the microcontrollers over I2C was a simple addition to the crates, but while I was at it, I decided to get the LED working. While I couldn't physically locate the LED controller, I managed to identified it as the IS31FL3194 after researching too many breathing I2C RGB LED controllers. Knowing this, I was able to build the first #link("https://github.com/LiamSnow/opensleep/tree/f2d1c7f82ad746b33c2437a667ce4c69ac93cd96/src/led")[Rust controller for it], enabling pretty complex effects.

After months of reverse-engineering, I felt happy with my implementation of the protocols and brought them into the opensleep repository, de-duplicating as much of their logic as I could. Then I built a new temperature-profile system, a configuration system, presence detection, and more. I centered it around MQTT, simplifying the interface and enabling opensleep to push to subscribers. I published it on both #link("https://www.reddit.com/r/rust/comments/1n8hu4p/opensleep_rust_firmware_for_the_eight_sleep_pod_3/")[r/rust] and #link("https://www.reddit.com/r/EightSleep/comments/1n8ppn8/opensleep_complete_firmware_for_the_eight_sleep/")[r/eightsleep], gaining 373 upvotes and 126 GitHub stars. I never thought that my initial purchase of a broken Eight Sleep Pod 3 would lead me here, but I am so happy that it did.



#pagebreak()
= liamsnow.com <liamsnow.com>

#link("https://liamsnow.com/projects/liamsnow_com")[Post] | #link("https://github.com/liamsnow/liamsnow.com")[GitHub]

I’ve been reading other programmers' blogs for a long time and have made many attempts at my own. My most recent version is written in Rust, has all content in #link("https://typst.app/")[Typst], uses a hand-rolled HTTP/1.1 implementation, achieves perfect marks on PageSpeed, and is hosted on Helios in my #link("https://liamsnow.com/projects/homelab")[homelab].

#link("https://typst.app/")[Typst] is essentially LaTeX with Markdown-like syntax and scripting. I’ve enjoyed using it for a long time and always wanted it for my website. Typst HTML output is still an experimental feature, constantly changing and #link("https://github.com/typst/typst/pull/7783")[sometimes breaking completely]. I decided that even in this state, I would attempt it anyway.

== Urls & Queries
I saw two ways to handle routing: explicitly defined URLs in files or implicitly defined URLs based of file path.
Explicit is simple to implement and makes indexing easy.
For example, since `/blog` needs to know about all the blog posts, it can simply read the file and build links to each post.

I really wanted to do implicit because it was nice to work with, but to do this, I needed a solution for indexes. The cleanest solution I came up with was to require each page to specify #link("https://typst.app/docs/reference/introspection/metadata/")[metadata] (like Markdown front matter) and then allow pages to query for this metadata from other pages. Then, the result of the query would be passed in as a #link("https://typst.app/docs/reference/foundations/sys/")[system input].
This supports not only `blog.typ` (needs blog posts), but also `index.typ` (blog posts and projects) and #link("igloo")[igloo's project page] (blog posts on only igloo, split by version).

== The Code
The code is divided up into three key modules: indexer, compiler, and web.

The indexer walks the root directory,
reading all files (Typst, SCSS, and other),
retrieves the metadata of all Typst pages,
guesses #link("https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/MIME_types")[MIME types],
and computes URLs from file paths.

The compiler takes the output from the indexer to compile all files (Typst → HTML, SCSS → CSS),
create HTTP responses (uncompressed/identy responses, #link("https://brotli.org/")[Brotli] compressed responses, 304 not modified, etag),
and build the routing table (URL path → HTTP response).

Both the indexer and compiler leverage #link("https://crates.io/crates/rayon")[rayon] to parallelize their steps. This was chosen over Tokio because of its synchronous nature (file reading, Typst compilation, ...).

After the compiler is done, the HTTP/1.1 web server starts running.
Its job is actually pretty simple, because all the responses are pre-made.
It accepts connections, reads the headers to find method, path, ETag, and Brotli support,
and ships out the corresponding response.

   
== Integrating Typst

My first prototype would simply spawn the Typst CLI as a process.
It ran on every file to query the metadata, and then it would be run again to compile the files.
I knew that this would always be slow, and getting around that would require me to integrate Typst directly.

Sadly, it was never intended to be used as a library, and it doesn’t make it easy. I found some experiments (#link("https://github.com/tfachmann/typst-as-library")[1], #link("https://github.com/Relacibo/typst-as-lib")[2]) that succeeded in doing it.
Although, they didn't support #link("https://typst.app/docs/reference/introspection/")[introspection] which I needed to read metadata, proper root directory handling, a recent Typst version, and good error messages.

Furthermore, I wasn't super happy with their implementations.
Instead, I opted to reference Typst internals directly.
I spent a long time understanding the internals, and was eventually able to build my own #link("https://github.com/LiamSnow/liamsnow.com/blob/main/src/compiler/typst.rs")[Typst World], which supplies everything needed to compile a Typst file, like file IO.

I designed this world with all the features I wanted, and to integrate seamlessly into my codebase. For example, I made it use an in-memory file system, removing all IO and repeated reads. Common dependencies, such as template files, are read once when the program starts (in the indexer), rather than on every compilation.

== Retrieving Typst Metadata
As mentioned, I was using Typst #link("https://typst.app/docs/reference/introspection/")[introspection] for retrieving metadata of every page, but it complicated the code and was slow.
Introspection requires the file to be compiled, which requires the in-memory file system to be setup, which requires the indexer to be finished.

This means that we must have an entire step dedicated to retrieving metadata at the end of the indexer. Not only does that directly slow us down, we just wasted time compiling a file, only to read \~7 trivial lines with no variables or dependencies.
 We can't merge this step with the compiler, because queries rely on metadata for every page to exist.
We also can't reuse the compilation from the indexer to produce the output HTML because the compilation didn't include system inputs like query results.

Eventually, with a lot more Typst source code digging, I solved these problems by implementing
#link("https://github.com/LiamSnow/liamsnow.com/blob/main/src/indexer/meta.rs")[my own parser]
that only parses the metadata fields.
Using this, we can combine the metadata retrieval with the file reading, reducing complexity and massively improving performance.

== Developer Features

After completing the main parts of the website, I moved onto improving my experience using the website.

I made a hot-reload system which updates the page as soon as you make a change in your editor.
The server waits for a create, remove, or modify in the content directory, then rebuilds the website and notifies WebSockets.
Each page has some HTML injected which connects a WebSocket and simply refreshes the page upon recieving a message.

Then, I made a CD (continous deployment) system that updates the live website upon a push to GitHub.
After a push, GitHub sends a webhook which `POST`s to `liamsnow.com/_update`.
The server then verifies this request, `git pull`'s, recompiles the Rust, and exits (causing #link("https://en.wikipedia.org/wiki/Service_Management_Facility")[SMF] to restart it in the new version).


#pagebreak()
= igloo <igloo>

#link("https://liamsnow.com/projects/igloo")[Post] | #link("https://github.com/liamsnow/igloo")[GitHub]

== Background  
#link("https://www.home-assistant.io/")[Home Assistant] is a smart home platform that can connect nearly any smart home product. It breaks down vendor lock-in and gives you a single platform to manage your entire home. On top of this, it supports scripting, custom dashboards, and automation. It makes smart homes fun and powerful.

Home Assistant got me interested in smart homes, and while I think it’s an amazing tool, it has many flaws. In summary, it requires expensive hardware to run, is unintuitive, unreliable, and insecure (#link("https://community.home-assistant.io/t/twenty-two-things-i-wish-id-known/585631")[1], #link("https://www.thesmarthomehookup.com/home-assistant-beginners-guide-2020-installation-addons-integrations-scripts-scenes-and-automations/")[2], #link("https://www.elttam.com/blog/pwnassistant/")[3]). While the Home Assistant developers and community are working hard to improve it, I think the real solution is a complete rewrite and re-thinking of how it works. This is why I am building Igloo.

My first version of Igloo taught me a lot, but most importantly, that this is a very big project. Home Assistant itself is millions of lines of code and had the most contributors of any project on GitHub in 2024 (#link("https://github.blog/news-insights/octoverse/octoverse-2024/")[1]). I knew that competing with it would be extremely hard, and to have a chance, Python support would be essential.

== Version 2  
I chose Igloo for my #link("https://www.wpi.edu/project-based-learning/project-based-education/major-qualifying-project")[Major Qualifying Project (MQP)], which meant I had an entire year to work on it. I decided on concrete goals (in order): intuitive, reliable, fast, secure, and capable of running effectively on at least a Raspberry Pi 3.  

The first thing I started with was the abstraction of devices. Home Assistant breaks devices down into multiple entities, each with a #link("https://developers.home-assistant.io/docs/core/entity/light/")[strict definition], like a light. This brings cohesion and is easy to work with at the cost of removing functionality from devices that don’t fit in perfectly. #link("https://www.openhab.org/")[openHAB] takes a more #link("https://www.openhab.org/docs/configuration/things.html")[flexible approach] at the cost of more upfront configuration. I opted for a #link("https://liamsnow.com/blog/igloo/ecs")[model] based on #link("https://en.wikipedia.org/wiki/Entity_component_system")[ECS ("Entity-Component-System")], which brings structure and flexibility. Instead of strictly defining what a light is, it would be composed of components such as a dimmer, a switch, and a color.

I spent a long time making the device tree and query engine. After optimizing it with #link("https://github.com/mstange/samply")[samply's] help, it could evaluate common queries in a mean of 220ns. While not very practical, I did this mainly for learning, and found a lot of #link("https://liamsnow.com/blog/igloo/oneshot_query")[interesting behavior]. After learning more, I managed to make a #link("https://github.com/LiamSnow/igloo-device-tree-testing")[prototype] that is both simpler and faster, achieving 1 billion queries per second.

To align with Igloo’s goal of being intuitive, I designed #link("https://liamsnow.com/blog/igloo/penguin")[Penguin], a node-based visual programming language (VPL) in #link("https://webassembly.org/")[WASM] for creating automations. It essentially required me to build my own Rust web framework and, as far as I understand, can support more nodes than any other node-based VPL.  
In response to #link("https://www.cisa.gov/news-events/alerts/2025/09/23/widespread-supply-chain-compromise-impacting-npm-ecosystem")[recent attacks on package managers], I planned to lock down Igloo providers (device drivers). While Docker solves this problem, it also increases resource utilization and complexity. I opted to go with separate processes secured similarly to #link("https://crates.io/crates/hakoniwa")[Hakoniwa] (cgroups, #link("https://docs.kernel.org/userspace-api/landlock.html")[Landlock], ...). This design also provides crash isolation and enabling/disabling of providers at runtime easily. WASM would be a better solution, but it #link("https://liamsnow.com/blog/igloo/wasm")[wasn't ready yet].

== Another Version?  
From the beginning, I have valued rigor and learning above all else in Igloo. I would always be happier working another year on the project to make something better. This is why I spent time exploring WASM and other options. At some point, I realized I kept going in circles, planning out changes to the project. I dug into the root cause of why I was doing this, which boiled down to not being happy with Igloo and where it was headed. I always wanted Igloo to help me easily build a very complex smart home, and I now know that this goal and the goal of creating an intuitive platform appealing to a broad audience are usually at odds. After stepping away from the project, I realized that targeting power users solely would both fulfill what I enjoyed most about programming and what I would want to use.

I’m not upset by the time I spent working on the first two versions. It also taught me a lot about what this project should be and the challenges it faces. Bryan Cantrill explains this well in #link("https://oxide.computer/blog/systems-software-in-the-large")[Systems Software in the Large] – Igloo feels like a project that will be "never completely solved, but also not even really understood until implementation is well underway."
