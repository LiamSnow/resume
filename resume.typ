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

== Skills
- *Programming Languages*: Rust (2 years), Golang, C, C++, Java, C\#, Python, TypeScript, JavaScript
- *Technologies*: REST, WebSockets, Multi-threading, Async/Await, SQL (SQLite, PostgreSQL, RDS), NoSQL (GC Datastore), Linux (Arch, Debian), Unix, Git, GitHub, CI/CD (GitHub Actions), Tokio, Axum, Actix, Dioxus, Leptos, Gin, Protobuf   

== Projects

#project(
  name: "opensleep (113★)",
  dates: dates-helper(start-date: "Nov 2024", end-date: "Present"),
  url: "liamsnow.com/projects/opensleep",
)
- Developed open source firmware for the Eight Sleep Pod 3 in Rust
- Reverse-engineered two custom USART protocols, reimplemented using custom Tokio codec
- Adds Home Assistant integration (via MQTT), custom temperature profiles, remote configuration, presence detection, and privacy
// TODO revise this ^^

#project(
  name: "igloo",
  dates: dates-helper(start-date: "Jan 2025", end-date: "Present"),
  url: "liamsnow.com/projects/igloo",
)
- Building open-source smart home platform in *Rust* as Home Assistant alternative; integrates ESPHome, HomeKit, MQTT with visual programming language for automations
- Built Entity-Component-System (ECS) model, allowing for strict component types while remaining extensible to new device types without core changes
- Implemented query engine achieving >1M queries/sec throughput with 4µs average latency (*200ns single execution*)
- Built extensive code generation system producing Component enums, type conversions, aggregators, and Python bindings from TOML definitions
- Created custom IPC protocol with forward-compatible schema evolution using length-delimited Bincode over Unix sockets

== Work Experience

#work(
  title: "Security Intern",
  location: "Remote",
  company: "Cyera, Inc.",
  dates: dates-helper(start-date: "Jun 2025", end-date: "Aug 2025"),
)
- Developed a security investigation summarizer Slack bot in Golang
  - Saves >100 hours a year
  - Collects data from Slack and other sources and builds a report using AWS Bedrock in \~1 minute 
- Made VM automation which automatically finds new CVEs across multiple security tools (Snyk, Upwind, etc.) and sends results over Slack
- Developed security news article downloader which automatically scrapes readable content from web pages and formats them into a NextJS article reader
- Made dashboard which displays security team's contributions to sales. Uses Atlassian Jira and Salesforce APIs in Golang

#work(
  title: "Software Intern",
  location: "Remote",
  company: "Phreesia, Inc.",
  dates: dates-helper(start-date: "Jun 2023", end-date: "Aug 2024"),
)
- Worked on a team to develop a complete rewrite of the Integrations software
  - Used .NET Core, Websockets, and REST APIs
- Developed Atlassian Confluence RAG chatbot to help users find answers and cite sources
  - Used Confluence API, OpenAI embeddings, ChromaDB, and LangChain 

#work(
  title: "Backend Developer",
  location: "Remote",
  company: "Veripay, LLC",
  dates: dates-helper(start-date: "May 2024", end-date: "Jul 2024"),
)
- Developed alpha prototype for startup in 10 weeks
- Used AWS, Terraform, Lambda functions, Golang, Gin, RDS

#work(
  title: "Software Intern",
  location: "Monterey, CA",
  company: "Naval Postgraduate School",
  dates: dates-helper(start-date: "Jun 2019", end-date: "Oct 2020"),
)
- Worked under Professor Ray Gamache for programming and assembling robots
- Programmed LIDAR, ultrasonic, radar, AHRS, and GPS sensors in LabVIEW

== Education

#edu(
  institution: "Worcester Polytechnic Institute",
  location: "Worcester, MA",
  dates: dates-helper(start-date: "Aug 2022", end-date: "May 2026"),
  degree: "BS in Electrical & Computer Engineering\nMS in Computer Science",
  // Uncomment the line below if you want edu formatting to be consistent with everything else
  // consistent: true
)

