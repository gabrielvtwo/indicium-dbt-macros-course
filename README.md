[![Indicium](https://c5gwmsmjx1.execute-api.us-east-1.amazonaws.com/prod/dados_processo_seletivo/logo_empresa/113528/marca_indicium_horizontal_grande.png_name_20220520-25985-2343zr.png)](https://www.indicium.tech/?r=0)

# dbt Macros
> How to extract value from this dbt feature?

This is the material for the Indicium Training dbt Macros course. In this repository, we have a selection of macros to explore and study jinja and macros and how to extract value from it in a real project.

Enroll the full course [in the training indicium page](https://training.indicium.tech/enrol/index.php?id=429).

### Setup

To run the macros directly from this repository, you need to have access to a BigQuery project with at least the following roles:

* BigQuery Data Editor
* BigQuery User

BigQuery has a nice free sandbox that can be used. Check [Google's documentation](https://cloud.google.com/bigquery/docs/sandbox) to setup your sandbox. BigQuery's free tier should be more than enough to test the macros**.

<sub><sup>
\*\* Especially the payload_publisher() macro will require a *roles/storage.admin* permission. You can learn how to create buckets [here](https://cloud.google.com/storage/docs/creating-buckets) and learn how to assign IAM roles [here](https://cloud.google.com/iam/docs/roles-overview?hl=pt-br).
</sup></sub>

To authenticate with your project, I recommend using OAuth authentication. For that, you will need to install gcloud and set it up. To learn how to do that, check dbt documentation [here](https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup#oauth-via-gcloud) and [here](https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup#local-oauth-gcloud-setup).

### Usage

#### Clone

Clone this repository with:

```bash
git clone 
```

#### Venv

Create a virtual environment as the following. First, go to the macros_training directory:

```bash
cd ~/path/to/this/macros_training/
```

And then create a python virtual environment:

```bash
python -m venv venv
```

Don't change it to anything else than 'venv' so .gitignore will ignore it.

Install the requirements:

```bash
pip install -r requirements.txt
```

#### Authentication

To check your authentication:

```bash
dbt debug
```

#### Running macros
To run a macro from CLI with dbt, use the following command:

```bash
dbt run-operation hello_world
```

Change "hello_world" for the macro's name.

To run a macro with arguments, use the --args argument, such as the following:

```bash
dbt run-operation hello_world --args "{'string':'Good Bye', 'other_string': 'Underworld'}"
```

Change "hello_world" to your macro's name, and the dictionary inside "{}" with the arguments you want to provide.

#### Running the pipeline

First, seed the only source we have here which is a csv with contracts.

```bash
dbt seed
```

Then, we can run the pipeline with dbt run using the data we just seeded:

```bash
dbt run
```

Notice in the src_sap.yml and src_northwind.yml files that we use the same environment variables from your .env and to generate the seed from your dev environment, so it is easier to config sources here.
This is of course not ideal for real projects, but here it will simplify some stuff.

### Contact

For feedback, tips and suggestion, please send me an email via gabriel.bernardo@indicium.tech (or message me via Bitrix 😎)