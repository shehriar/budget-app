create new bundle:
powershell -ExecutionPolicy Bypass -File .\bundle-creator.ps1 {bundleName}

Maven:
run backend:
.\mvnw spring-boot:run `-Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"

clean compile:
.\mvnw clean compile
