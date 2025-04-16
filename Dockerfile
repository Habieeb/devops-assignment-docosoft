# Stage 1 - Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

# Copy solution and project files
COPY CounterApi.sln ./
COPY src/CounterApi.csproj ./src/

# Restore dependencies
RUN dotnet restore

# Copy the full source code
COPY src/ ./src/

# Build the project
WORKDIR /app/src
RUN dotnet build -c Release -o /app/build

# Stage 2 - Publish
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

WORKDIR /app

# Copy built app from build stage
COPY --from=build /app/build ./

# Expose port (optional, if running inside a container)
EXPOSE 80

# Start the application
ENTRYPOINT ["dotnet", "CounterApi.dll"]
