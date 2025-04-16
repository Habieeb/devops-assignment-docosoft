# Use the official image as the base
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the solution file and the src folder to the container
COPY CounterApi.sln ./
COPY src ./src
COPY tests ./tests

# Restore the dependencies
RUN dotnet restore

# Build the solution
RUN dotnet build CounterApi.sln -c Release --no-restore

# Publish the application
RUN dotnet publish CounterApi.sln -c Release -o /app/publish --no-build

# Set the base image for the runtime environment
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

# Set the working directory
WORKDIR /app

# Copy the published files from the build stage
COPY --from=build /app/publish .

# Set the entry point for the application
ENTRYPOINT ["dotnet", "src/CounterApi.dll"]
