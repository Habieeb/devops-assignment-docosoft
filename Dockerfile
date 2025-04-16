# Stage 1 - Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

# Copy solution and project files
COPY CounterApi.sln ./
COPY src/CounterApi/CounterApi.csproj ./src/

# Restore dependencies
RUN dotnet restore

# Copy everything else
COPY src/ ./src/

# Build the project
WORKDIR /app/src
RUN dotnet build -c Release -o /app/build

# Stage 2 - Publish
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

WORKDIR /app

# Copy published build from the previous stage
COPY --from=build /app/build ./

# Expose port
EXPOSE 80

# Start the app
ENTRYPOINT ["dotnet", "CounterApi.dll"]
