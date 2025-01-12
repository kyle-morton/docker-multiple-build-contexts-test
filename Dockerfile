FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# copy csproj to workdir, restore nuggets
COPY ConsoleApp/*.csproj ./ConsoleApp/
COPY RefProjectOne/*.csproj ./RefProjectOne/
COPY RefProjectTwo ./RefProjectTwo/

RUN dotnet restore ./ConsoleApp/ConsoleApp.csproj

# # publish app to local dir
COPY . ./
RUN dotnet publish ConsoleApp/*.csproj -c Release -o out

# # run the runtime image, and copy over the built app
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# # RUN the app 
ENTRYPOINT [ "dotnet", "ConsoleApp.dll" ]


