# build-numbers-action
This GitHub Action keeps build numbers in a separate repository and allows you to increment and get build numbers in your workflow.

# Example Workflow
    name: Get a new build number

    on: push

    jobs:
      build-number:
        runs-on: ubuntu-latest
        steps:
        - name: Checkout
          uses: actions/checkout@v2

        - name: Increase the build number
          id: action
          uses: modestman/build-numbers-action@master
          env:
            API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}
          with:
            app_name: 'ios-app'
            versions_repo: 'modestman/app-versions'
            should_increase_version: true
            user_email: 'mail@example.com'
            user_name: 'CI'
            commit_message: 'A custom message for the commit'

        - name: Get the output build number
          # Use the output from the `action` step
          run: |
            echo "The build number is: ${{ steps.action.outputs.build_number }}"

# Variables

The `API_TOKEN_GITHUB` needs to be set in the `Secrets` section of your repository options. You can retrieve the `API_TOKEN_GITHUB` [here](https://github.com/settings/tokens) (set the `repo` permissions).

* **app_name**: The name of your app. This name is used to read the file with the build number, if the file doesn't exist it will be created.
* **versions_repo**: The repository where version files are stored.
* **user_email**: The GitHub user email associated with the API token secret.
* **user_name**: The GitHub username associated with the API token secret.
* **destination_branch**: [optional] The branch of the versions repo to update, if not master.
* **should_increase_version**: [optional] The flag indicating that it is necessary to increase the build number. Default `true`. If `false`, the current build number will be returned.
* **commit_message**: [optional] A custom commit message for the commit. Defaults to `Increased build number of $APP_NAME: $VERSION`

### Output

You can get build number from action output by id `build_number`, see example above.