using Dapr.Client;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);
var client = new DaprClientBuilder()
                .Build();

builder.Services.AddOpenApi();
builder.Services.AddSingleton<DaprClient>(client);


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

string DAPR_STORE_NAME = "statestore";

app.MapGet("/get-state/{id}", async ([FromServices]DaprClient client, string id) =>
{
     var result = await client.GetStateAsync<Employee>(DAPR_STORE_NAME, id);
    return result;
})
.WithName("GetStoredState");


app.MapPost("/set-state", async ([FromServices]DaprClient client, [FromBody]Employee value) =>
{
   await client.SaveStateAsync(DAPR_STORE_NAME, value.Id, value);
   return Results.Created();
})
.WithName("SetStoredState");


app.Run();

record Employee(string Id, string Name, DateOnly? DOB);
