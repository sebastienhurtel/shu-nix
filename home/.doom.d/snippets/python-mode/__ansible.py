import yaml
from ansible.module_utils.basic import AnsibleModule


def main():
    # Définissez les options acceptées par le module. ❶
    module_args = dict(
        user=dict(type='str', required=True),
        password=dict(type='str', required=True, no_log=True),
        data=dict(type='str', required=True),
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    result = dict(
        changed=False
    )

    got = {}
    wanted = {}

    # Renseignez les variables `got` et `wanted`. ❷
    # […]

    if got != wanted:
        result['changed'] = True
        result['diff'] = dict(
            before=yaml.safe_dump(got),
            after=yaml.safe_dump(wanted)
        )

    if module.check_mode or not result['changed']:
        module.exit_json(**result)

    # Appliquez les changements. ❸
    # […]

    module.exit_json(**result)


if __name__ == '__main__':
    main()
