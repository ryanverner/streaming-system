This script is used to register a flumotion encoder server onto the timvideos frontend system.
This should be ran on the encoder machines.

Usage (run as root in a screen/tmux session):

```python register_wrapper.py -m user:password@encoder-server -g group -s sharedsecret```

(where:
 * user:password equal flumotion manager username/password,
 * group equals group/room in config.private.json on timvideos frontend,
 * sharedsecret is secret in config.private.json on timvideos frontend

fake_register.py can be used to test room registration (see parent README.md)
