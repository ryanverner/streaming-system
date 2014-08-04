This is used to watch and restart flumotion components.
This should be ran on the collector + encoder machines.

Usage (run as root in a screen/tmux session):

```python watchdog_wrapper.sh -m user:password@127.0.0.1```

(where user:password equal flumotion manager username/password)

manager username/password can be found in:
/usr/local/etc/flumotion/workers/default.xml

