Setup steps for `rclone` sync with Google Drive.

### How to Configure the Google Drive Remote ⚙️

This process will guide you through the `rclone config` wizard to securely connect your Google account. It will create/update the configuration file located at `~/.config/rclone/rclone.conf`.

1.  **Create client_id**

Use private client_id for transfers. The default one is shared with all other rclone users. To create a new client_id, follow the instructions from:

- https://rclone.org/drive/#making-your-own-client-id

Note to myself: I have this info saved in the password manager.

2.  **Start the configuration tool**:

    ```bash
    rclone config
    ```

3.  **Create a New Remote**: Type `n` and press **Enter**.

4.  **Name your remote**: This is a nickname you'll use in commands. Let's use `gdrive`. Type `gdrive` and press **Enter**.

5.  **Choose Storage Type**: A long list of cloud providers will appear. Find "Google Drive" and type its corresponding number (it's usually `22`), then press **Enter**.

6.  **Google Application Credentials**: The wizard will ask for a `client_id` and `client_secret`. Use the ones created in the previous step.

7.  **Choose Access Scope**: You'll be asked what level of access rclone should have. For full sync capabilities, choose option `1` ("Full access to all files") and press **Enter**.

8.  **Skip Advanced Options**:

      * For `root_folder_id`, press **Enter** to leave it blank (this defaults to your "My Drive" root).
      * For `service_account_file`, press **Enter** to leave it blank.
      * When asked "Edit advanced config?", type `n` and press **Enter**.

9.  **Authorize rclone (The Credential Step)**:

      * You'll be asked, "Use auto config?". Type `y` and press **Enter**.
      * This will automatically open a web browser page. You may need to log in to your Google account.
      * Google will ask you to grant `rclone` permission to access your files. Click **"Allow"**.
      * Once authorized, you'll see a "Success\!" message in the browser. You can close the browser tab and return to your terminal.

10.  **Configure as Team Drive?**: If you are syncing a personal drive (not a "Shared Drive"), type `n` and press **Enter**.

11. **Confirm and Quit**: You'll see a summary of the `gdrive` remote you just created. If everything looks correct, type `y` to save it, then type `q` to quit the configuration tool.

Your credentials are now securely stored as an access token inside `~/.config/rclone/rclone.conf`.

### How to Run a Two-Way Sync via CLI 🔄

For a true two-way sync (both uploads and downloads), the correct command is **`rclone bisync`**. Unlike `rclone sync`, which is a destructive one-way mirror, `bisync` tracks changes on both sides to prevent accidental data loss.

Let's assume you want to sync the folder `~/gdrive` on your computer with the root folder on your Google Drive.
 
1.  **First-Time Sync (Crucial Step)**: The very first time you run `bisync` between two locations, you must use the `--resync` flag. This establishes a baseline by comparing both sides and making them identical.

    ⚠️ **Safety First\!** Always perform a dry run before the initial `--resync` to see what changes will be made without actually doing anything. The `-v` flag adds verbosity.

    ```bash
    rclone bisync -v --dry-run ~/gdrive gdrive: --filter-from ~/.config/rclone/rclone-filters.txt --resync
    ```

    Review the output carefully. If it looks correct, run the command for real:

    ```bash
    rclone bisync -v ~/gdrive gdrive: --filter-from ~/.config/rclone/rclone-filters.txt --resync
    ```

2.  **Subsequent Syncs**: After the initial run, **do not use `--resync` again**. For all future syncs, the command is much simpler. It will check for changes on both sides and propagate them.

    ```bash
    rclone bisync -v ~/gdrive gdrive: --filter-from ~/.config/rclone/rclone-filters.txt
    ```

This command will now:

  * **Upload** any new or modified files from `~/gdrive` to `gdrive:`.
  * **Download** any new or modified files from `gdrive:` to `~/gdrive`.
  * Propagate deletions from one side to the other.
  * **Ignore** the `Old-Drive` folder completely because of your filter rule.
