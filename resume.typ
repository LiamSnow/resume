#import "@preview/basic-resume:0.2.8": *

// Put your personal information here, replacing mine
#let name = "William (Liam) Snow IV"
#let email = "mail@liamsnow.com"
#let github = "github.com/liamsnow"
#let linkedin = "linkedin.com/in/william-snow-iv-140438169"
#let personal-site = "liamsnow.com"

#show: resume.with(
  author: name,
  // All the lines below are optional.
  // For example, if you want to to hide your phone number:
  // feel free to comment those lines out and they will not show.
  email: email,
  github: github,
  linkedin: linkedin,
  personal-site: personal-site,
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
- *Programming Languages*: Rust (2 years), Golang, C, C++, Java, C\#, Python, TypeScript, JavaScript, Bash
- *Technologies*: Tokio, Axum, Actix, Dioxus, Leptos, Gin, SQL (SQLite, PostgreSQL, RDS), NoSQL (GC Datastore), Embedded Databases (SledDB), Embeddings/Vector Databases (ChromaDB), Linux (Debian, Yocto, Arch, NixOS), Unix, Git, GitHub, CI/CD (GitHub Actions), REST, WebSockets, GCP, Multi-threading, Async/Await

== Projects

#project(
  name: "opensleep (81★)",
  dates: dates-helper(start-date: "Nov 2024", end-date: "Present"),
  url: "github.com/liamsnow/opensleep",
)
- Developed open source firmware for the Eight Sleep Pod 3 in Rust
- Reverse-engineering two custom USART protocols
- Runs MQTT, STM32 comms, scheduler, presence detection, ..

#project(
  name: "igloo",
  dates: dates-helper(start-date: "Jan 2025", end-date: "Present"),
  url: "liamsnow.com/projects/igloo",
)
- Intuitive and smart home automation platform connecting 10+ providers 
- Developed visual node-based programming language with custom lexer, parser, and evaluation. Uses Dioxus for front-end
- Handles concurrent connection to 100+ devices
- Clean Axum API (Websocket + REST). Custom rolled authentication & permissions 


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

