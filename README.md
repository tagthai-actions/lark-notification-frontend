
# Lark Notification Frontend

This GitHub Action is designed to send customizable notification messages to Lark after deployments, using the Lark Interactive Card API.

## Features

- Supports sending deployment summaries to Lark with structured card templates
- Accepts input parameters for environment name, deployer, service names, version numbers, etc.
- Three modes of notification:
  - `default`: sends notifications from a single CSV source file
  - `matrix`: processes multiple CSV files dynamically based on input modules
  - `develop`: used for development environments, using custom commit message payloads

## Usage

You can use this action in your GitHub workflow as follows:

```yaml
jobs:
  notify:
    runs-on: ubuntu-latest
    needs: set_matrix
    steps:
      - name: Send Lark Notification
        uses: tagthai-actions/lark-notification-frontend@v1
        with:
          card_type: matrix
          service_name: ${{ needs.set_matrix.outputs.environments }} # JSON array e.g. ["content", "mobile"]
          actor: ${{ github.actor }}
          repository: ${{ github.repository }}
          ref: ${{ github.ref }}
```

## Inputs

| Name           | Required | Description                                                                 |
|----------------|----------|-----------------------------------------------------------------------------|
| `card_type`    | Yes      | Either `default` or `matrix`                                                |
| `service_name` | Yes      | For `default`, it is a string; for `matrix`, a JSON array of module names   |
| `actor`        | Yes      | GitHub actor who triggered the deployment                                   |
| `repository`   | Yes      | GitHub repository name                                                      |
| `ref`          | Yes      | GitHub ref/tag/branch deployed                                              |
| `tag`          | No       | Optional tag input pipeline                                                 |

## Data Source

CSV files must exist in the following paths:
- For `default` mode: `helm-chart/release_control_content.csv`
- For `matrix` mode: `helm-chart/release_control_admin_web_{module}.csv`

Each CSV must follow the structure:

```
SERVICE, VERSION
tgth-adminweb-main, v1.0.0
tgth-v2-content, v3.2.11
...
```

## Output

An interactive Lark card will be sent using webhook, displaying:
- Environment (e.g., UAT, DEV)
- Deployer name
- Application version
- List of services and their versions

## License

MIT

