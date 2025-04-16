# Use the official .NET SDK image for building the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy csproj and restore dependencies
COPY *.sln .
COPY src/CounterAPI/*.csproj ./src/CounterAPI/
RUN dotnet restore

# Copy everything else and build the app
COPY . .
WORKDIR /app/src/CounterAPI
RUN dotnet publish -c Release -o /out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /out .

ENTRYPOINT ["dotnet", "CounterApi.dll"]    #trrtr
