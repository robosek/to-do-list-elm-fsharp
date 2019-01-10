FROM andrewlock/dotnet-mono as build
COPY . /app
WORKDIR /app/src
RUN dotnet publish -c Release --self-contained -r linux-x64 -o output

FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
COPY --from=build /app/src/output .
ENTRYPOINT ["dotnet", "api.dll"]