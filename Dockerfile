# Use the official .NET image as the base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use the SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the solution and the csproj file(s)
COPY *.sln ./
COPY src/CounterApi.csproj ./src/

# Restore dependencies
RUN dotnet restore

# Copy all other files
COPY . .

WORKDIR /src
RUN dotnet build CounterApi.sln -c Release -o /app/build

FROM build AS publish
RUN dotnet publish CounterApi.sln -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CounterAPI.dll"]
