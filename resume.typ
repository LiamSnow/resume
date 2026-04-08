#import "@preview/basic-resume:0.2.8": *

#show: resume.with(
  author: "William (Liam) Snow IV",
  email: "mail@liamsnow.com",
  github: "github.com/liamsnow",
  linkedin: "linkedin.com/in/william-snow-iv-140438169",
  personal-site: "liamsnow.com",
  accent-color: "#26428b",
  font: "New Computer Modern",
  paper: "us-letter",
  author-position: left,
  personal-info-position: left,
)

/*
* Lines that start with == are formatted into section headings
* You can use the specific formatting functions if needed
* The following formatting functions are listed below
* #edu(dates: "", degree: "", gpa: "", institution: "", location: "", consistent: false)
* #work(company: "", dates: "", location: "", title: "")
* #project(dates: "", name: "", role: "", url: "")
* certificates(name: "", issuer: "", url: "", date: "")
* #extracurriculars(activity: "", dates: "")
* There are also the following generic functions that don't apply any formatting
* #generic-two-by-two(top-left: "", top-right: "", bottom-left: "", bottom-right: "")
* #generic-one-by-two(left: "", right: "")
*/

== Education

#edu(
  institution: "Worcester Polytechnic Institute",
  location: "Worcester, MA",
  dates: dates-helper(start-date: "Aug 2022", end-date: "May 2026"),
  degree: "BS in Electrical & Computer Engineering\nMS in Computer Science  GPA:3.7",
  // Uncomment the line below if you want edu formatting to be consistent with everything else
  // consistent: true
)

== Skills
- *Languages*: Rust #box(image("cuddlyferris.svg", width: 10pt)), Golang, C, Java, C\#, SystemVerilog, Python, TypeScript, JavaScript, WIT
- *Systems*: atomics, epoll, non-blocking IO, shared memory, multi-threading, async/await   
- *OS*: Linux (Arch, Debian, Talos), Illumos (Helios), Unix
- *Other*: WASM, AWS, Docker, Kubernetes, SQL, NoSQL, Git, CI/CD

== Projects

#project(
  name: "opensleep (128★)",
  dates: dates-helper(start-date: "Nov 2024", end-date: "Present"),
  url: "liamsnow.com/projects/opensleep",
)
- Developed open source firmware for the Eight Sleep Pod 3 in Rust, which is more powerful & completely private
- Reverse-engineered C++ binary (including 2 bespoke UART protocols) using a custom harness/tracer
- Provides presence detection over MQTT, enabling smart home automations such as reading your calendar when you get out of bed

#project(
  name: "liamsnow.com",
  dates: dates-helper(start-date: "Jan 2026", end-date: "Present"),
  url: "liamsnow.com/projects/liamsnow_com",
)
- Created a fast personal website in Rust and Typst
- Hand rolled HTTP/1.1 server with near zero-copy response dispatching (pre-compressed & pre-encoded responses)
- Made custom Typst world with an in-memory filesystem and rayon parallel compilation, achieving *\~130ms builds*
- Hosted on Helios illumos in my home lab, requiring patching and upstream PRs to libc, Fish, and rust-rpxy 

#project(
  name: "igloo",
  dates: dates-helper(start-date: "Jan 2025", end-date: "Present"),
  url: "liamsnow.com/projects/igloo",
)
- Building a FOSS, DIY smart home Rust library which enables more complex smart homes
- Introduced a new device model based on ECS (entity-component-system), which fully expresses devices' capabilities while maintaining cohesion
- Revised query engine 4x, bringing it from its initial 22k QPS (queries per second) to over *1 billion QPS*
- Created a visual node-based programming language in WASM (WebAssembly) with a bespoke framework built on wasm-bindgen, easily supporting over 10k nodes 

== Work Experience

#work(
  title: "Software Engineer",
  location: "Remote",
  company: [Cyera #sym.dot.op Internship],
  dates: dates-helper(start-date: "Jun 2025", end-date: "Aug 2025"),
)
- Developed Golang tool to assist during and after security investigations
  - Can be instrumental for velocity and clarity during investigations
  - Saves $>100$ hours a year of manual work for creating post-mortems
- Made vulnerability management automation which alerts engineers about new CVEs from Snyk and Upwind
- Created Golang automation that aggregates data from Atlassian Jira and Salesforce to calculate the security team's contributions to sales

#work(
  title: "Software Engineer",
  location: "Remote",
  company: [Phreesia #sym.dot.op Internship],
  dates: dates-helper(start-date: "Jun 2023", end-date: "Aug 2024"),
)
- Worked on MVP for a major rewrite of the Integrations software, improving the architecture, code quality, and upgrading to .NET Core 
- Developed search interface to help engineers find documentation more easily

// #work(
//   title: "Backend Developer",
//   location: "Remote",
//   company: "Veripay, LLC",
//   dates: dates-helper(start-date: "May 2024", end-date: "Jul 2024"),
// )
// - Developed alpha prototype for startup in 10 weeks
// - Used AWS, Terraform, Lambda functions, Golang, Gin, RDS

#work(
  title: "Software Engineer",
  location: "Monterey, CA",
  company: [Naval Postgraduate School #sym.dot.op Internship],
  dates: dates-helper(start-date: "Jun 2019", end-date: "Oct 2020"),
)
- Worked under Professor Ray Gamache, setting up and running labs
- Created LabVIEW libraries for LIDAR, ultrasonic, radar, AHRS, and GPS


